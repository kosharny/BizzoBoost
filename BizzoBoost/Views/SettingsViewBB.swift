import SwiftUI

struct SettingsContentViewBB: View {
    @EnvironmentObject var storeManager: StoreManagerBB
    @EnvironmentObject var viewModel: ViewModelBB
    
    @State private var selectedThemeForPaywall: ThemeModelBB?
    @State private var showResultAlert = false
    @State private var resultTitle = ""
    @State private var resultMessage = ""

    var body: some View {
        NavigationView {
            ZStack {
                viewModel.currentTheme.backgroundGradient
                .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        // Themes Carousel
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Themes")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    ThemeCardBB(theme: ViewModelBB.defaultTheme)
                                    ThemeCardBB(theme: ViewModelBB.cyberNightTheme)
                                    ThemeCardBB(theme: ViewModelBB.goldenHourTheme)
                                }
                                .padding(.horizontal)
                            }
                        }

                        // Premium Promo (Hidden if Premium is bought)
                        if !viewModel.premiumEnabled {
                            Button {
                                selectedThemeForPaywall = ViewModelBB.cyberNightTheme
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Upgrade Plan")
                                            .font(.headline)
                                            .foregroundColor(ThemeBB.primaryIndigo)
                                        Text("Unlock all themes, unlimited goals, export stats")
                                            .font(.caption)
                                            .foregroundColor(ThemeBB.primaryIndigo.opacity(0.8))
                                            .multilineTextAlignment(.leading)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(ThemeBB.primaryIndigo)
                                }
                                .padding()
                                .background(ThemeBB.premiumGold)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: ThemeBB.premiumGold.opacity(0.5), radius: 10)
                            }
                            .padding(.horizontal)
                        }

                        // About Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("About")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.horizontal)

                            VStack(spacing: 0) {
                                NavigationLink(destination: AboutViewBB()) {
                                    HStack {
                                        Text("About Bizzo Boost")
                                            .foregroundColor(.white)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(ThemeBB.neonMint)
                                    }
                                    .padding()
                                }
                                
                                Divider().background(.white.opacity(0.2))
                                
                                Button {
                                    Task {
                                        await storeManager.restorePurchases()
                                        resultTitle = "Restore Complete"
                                        resultMessage = "Your previous purchases have been restored if they exist."
                                        showResultAlert = true
                                    }
                                } label: {
                                    HStack {
                                        Text("Restore Purchases")
                                            .foregroundColor(.white)
                                        Spacer()
                                        Image(systemName: "arrow.triangle.2.circlepath")
                                            .foregroundColor(ThemeBB.electricBlue)
                                    }
                                    .padding()
                                }
                                
                                Divider().background(.white.opacity(0.2))
                                
                                NavigationLink(destination: WebViewBB(urlString: "https://www.youtube.com/watch?v=ZXsQAXx_ao0").navigationTitle("Tutorial")) {
                                    HStack {
                                        Text("Watch Tutorial")
                                            .foregroundColor(.white)
                                        Spacer()
                                        Image(systemName: "play.circle.fill")
                                            .foregroundColor(ThemeBB.accentGlow)
                                    }
                                    .padding()
                                }
                            }
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 100)
                }
                .navigationTitle("Settings")
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbarBackground(.hidden, for: .navigationBar)
            }
        }
        .sheet(item: $selectedThemeForPaywall) { theme in
            PaywallViewBB(theme: theme)
        }
        .customAlertBB(isPresented: $showResultAlert, alert: CustomAlertBB(
            title: resultTitle,
            message: resultMessage,
            primaryButton: CustomAlertButtonBB(title: "OK", isPrimary: true, action: {}),
            secondaryButton: nil
        ))
    }
}

struct ThemeCardBB: View {
    let theme: ThemeModelBB
    @EnvironmentObject var viewModel: ViewModelBB
    @EnvironmentObject var storeManager: StoreManagerBB
    
    // The binding proxy to bubble up to the parent SettingsView sheet
    // Because this view is extracted, we can't directly show the sheet here cleanly without parent knowledge usually,
    // but in SwiftUI iOS 16, sheets can safely sit anywhere if structured well.
    // For simplicity of strictly following the Store1 user instructions:
    // "if hasAccess { selectTheme } else { selectedThemeForPaywall = theme }"
    // We pass the selection up implicitly or use a binding. Usually it's handled right in the tap gesture.
    
    var body: some View {
        let isSelected = viewModel.currentTheme.id == theme.id
        let hasAccess = storeManager.hasAccess(to: theme)
        let color = Color(hex: theme.colorHex)
        
        Button {
            if hasAccess {
                viewModel.selectTheme(theme)
            } else {
                // Post Notification to Parent or use a global manager for paywalls
                // Since user specified the setup, we can also put a hidden sheet here
                NotificationCenter.default.post(name: NSNotification.Name("ShowPaywallBB"), object: theme)
            }
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                // Theme Preview Circle
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [color, color.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                        
                    if !hasAccess {
                        Image(systemName: "lock.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    } else if isSelected {
                        Image(systemName: "checkmark")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(theme.title)
                            .font(.headline)
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        if theme.isPremium {
                            Text("PRO")
                                .font(.system(size: 8, weight: .bold))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(ThemeBB.accentGlow)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                        }
                    }
                    
                    if !hasAccess {
                        Text(theme.priceString)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.5))
                    } else {
                        Text(isSelected ? "Active" : "Unlocked")
                            .font(.subheadline)
                            .foregroundColor(isSelected ? ThemeBB.neonMint : .white.opacity(0.5))
                    }
                }
                
                Spacer(minLength: 0)
            }
            .padding()
            .frame(width: 160, height: 180, alignment: .topLeading)
            .contentShape(Rectangle())
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? color : Color.clear, lineWidth: 2)
            )
            .shadow(color: isSelected ? color.opacity(0.3) : .clear, radius: 10)
        }
        .buttonStyle(.plain)
    }
}

// Global Notification Wrapper for the Paywall
struct SettingsViewBB: View {
    @State private var paywallTheme: ThemeModelBB?
    
    var body: some View {
        SettingsContentViewBB()
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ShowPaywallBB"))) { notification in
                if let theme = notification.object as? ThemeModelBB {
                    paywallTheme = theme
                }
            }
            .sheet(item: $paywallTheme) { theme in
                PaywallViewBB(theme: theme)
            }
    }
}

#Preview {
    SettingsViewBB().environmentObject(ViewModelBB()).environmentObject(StoreManagerBB())
}
