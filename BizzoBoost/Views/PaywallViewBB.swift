import SwiftUI
import StoreKit

struct PaywallViewBB: View {
    let theme: ThemeModelBB?
    
    @StateObject private var store = StoreManagerBB.shared
    @Environment(\.dismiss) var dismiss
    
    @State private var showConfirmAlert = false
    @State private var showResultAlert = false
    @State private var resultMessage = ""
    @State private var resultTitle = ""
    @State private var isSuccess = false
    @State private var selectedProduct: Product?

    var targetTheme: ThemeModelBB {
        theme ?? ViewModelBB.cyberNightTheme
    }

    var body: some View {
        ZStack {
            targetTheme.backgroundGradient
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                VStack(spacing: 20) {
                    ZStack {
                        let color = Color(hex: targetTheme.colorHex)
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [color, color.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 120, height: 120)
                            .shadow(color: color.opacity(0.5), radius: 20)
                        
                        Image(systemName: "crown.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                    }
                    .padding(.top, 40)
                    
                    Text(targetTheme.title)
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(ThemeBB.premiumGold)
                    
                    Text("Unlock this exclusive premium theme")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal)
                
                // Features
                VStack(alignment: .leading, spacing: 16) {
                    FeatureRowBB(
                        icon: "paintpalette.fill",
                        title: "Unique Color Palette",
                        description: "Experience the app in stunning new colors"
                    )
                    
                    FeatureRowBB(
                        icon: "infinity.circle.fill",
                        title: "Unlimited Goals",
                        description: "Break the daily creation limit"
                    )
                    
                    FeatureRowBB(
                        icon: "chart.bar.fill",
                        title: "Advanced Statistics",
                        description: "Export data and view deeper insights"
                    )
                }
                .padding(.vertical, 40)
                .padding(.horizontal, 24)
                
                Spacer()
                
                // Purchase Section
                if let product = store.products.first(where: { $0.id == targetTheme.id }) {
                    VStack(spacing: 16) {
                        // Purchase Button
                        Button {
                            selectedProduct = product
                            showConfirmAlert = true
                        } label: {
                            HStack {
                                Image(systemName: "crown.fill")
                                Text("Unlock for \(product.displayPrice)")
                                    .fontWeight(.bold)
                            }
                            .font(.headline)
                            .foregroundColor(ThemeBB.primaryIndigo)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [ThemeBB.premiumGold, ThemeBB.premiumGold.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: ThemeBB.premiumGold.opacity(0.3), radius: 10)
                        }
                        
                        // Restore Button
                        Button {
                            Task {
                                await store.restorePurchases()
                                if store.hasAccess(to: targetTheme) {
                                    resultTitle = "Success"
                                    resultMessage = "Your purchases have been restored!"
                                    isSuccess = true
                                    showResultAlert = true
                                } else {
                                    resultTitle = "No Purchases Found"
                                    resultMessage = "We couldn't find any previous purchases for this theme."
                                    isSuccess = false
                                    showResultAlert = true
                                }
                            }
                        } label: {
                            Text("Restore Purchases")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    .padding(.horizontal, 24)
                } else {
                    VStack(spacing: 10) {
                        if store.isLoading {
                            ProgressView()
                                .tint(ThemeBB.premiumGold)
                            Text("Loading products...")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                        } else {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.yellow)
                            Text("Product not found")
                                .foregroundColor(.white.opacity(0.6))
                            Text("ID: \(targetTheme.id)")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            
                            Button("Retry") {
                                Task { await store.fetchProducts() }
                            }
                            .padding(.top, 5)
                        }
                    }
                    .padding()
                }
                
                // Close Button
                Button {
                    dismiss()
                } label: {
                    Text("Not Now")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
        }
        .customAlertBB(isPresented: $showConfirmAlert, alert: confirmAlert)
        .customAlertBB(isPresented: $showResultAlert, alert: resultAlert)
        .task {
            if store.products.isEmpty {
                await store.fetchProducts()
            }
        }
    }
    
    // Confirmation Alert
    var confirmAlert: CustomAlertBB {
        CustomAlertBB(
            title: "Confirm Purchase",
            message: "Unlock \(targetTheme.title) for \(selectedProduct?.displayPrice ?? "")?\n\nThis is a one-time purchase.",
            primaryButton: .init(title: "Purchase", isPrimary: true) {
                showConfirmAlert = false
                Task {
                    await performPurchase()
                }
            },
            secondaryButton: .init(title: "Cancel") {
                showConfirmAlert = false
            }
        )
    }
    
    // Result Alert
    var resultAlert: CustomAlertBB {
        CustomAlertBB(
            title: resultTitle,
            message: resultMessage,
            primaryButton: .init(title: "OK", isPrimary: true) {
                showResultAlert = false
                if isSuccess && store.hasAccess(to: targetTheme) {
                    dismiss()
                }
            },
            secondaryButton: nil
        )
    }

    func performPurchase() async {
        guard let product = selectedProduct else { return }
        
        let status = await store.purchase(product)
        
        switch status {
        case .success:
            if store.hasAccess(to: targetTheme) {
                resultTitle = "Success!"
                resultMessage = "\(targetTheme.title) has been unlocked. Enjoy!"
                isSuccess = true
                showResultAlert = true
            }
            
        case .cancelled:
            print("User cancelled purchase")
            showResultAlert = false
            
        case .pending:
            resultTitle = "Pending"
            resultMessage = "Your purchase is pending approval."
            isSuccess = false
            showResultAlert = true
            
        case .failed:
            resultTitle = "Purchase Failed"
            resultMessage = "We couldn't complete your purchase. Please try again."
            isSuccess = false
            showResultAlert = true
        }
    }
}

struct FeatureRowBB: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(ThemeBB.premiumGold)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(ThemeBB.premiumGold.opacity(0.2), lineWidth: 1)
        )
    }
}
