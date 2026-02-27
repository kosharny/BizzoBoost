import Combine
import StoreKit
import SwiftUI

@MainActor
final class StoreManagerBB: ObservableObject {
    static let shared = StoreManagerBB()
    
    @Published var products: [Product] = []
    @Published var purchasedProductIDs: Set<String> = []
    @Published var isLoading = false
    @Published var entitlementsLoaded = false
    @Published var pendingPurchaseIntent: PurchaseIntent?
    
    private let productIDs: Set<String> = [
        "premium_theme_cyber_night",
        "premium_theme_golden_hour"
    ]
    
    var hasPurchasedAllThemes: Bool {
        productIDs.isSubset(of: purchasedProductIDs)
    }
    
    private var updatesTask: Task<Void, Never>? = nil
    
    init() {
        Task {
            await fetchProducts()
            await updatePurchasedProducts()
        }
        Task {
            await observeTransactions()
        }
        Task {
            await listenForStoreIntents()
        }
    }
    
    deinit {
        updatesTask?.cancel()
    }
    
    func fetchProducts() async {
        isLoading = true
        
        do {
            let fetchedProducts = try await Product.products(for: productIDs)
            self.products = fetchedProducts.sorted(by: { $0.price < $1.price })
            
            if fetchedProducts.isEmpty {
                print("🔴 ATTENTION: StoreKit returned empty product list! Verify product IDs in App Store Connect.")
            }
            
        } catch {
            print("🔴 Error loading products: \(error)")
        }
        
        isLoading = false
    }
    
    func purchase(_ product: Product) async -> PurchaseStatusBB {
        do {
            let result = try await product.purchase()
            return try await handlePurchaseResult(result)
        } catch {
            return .failed
        }
    }
    
    func purchaseWithPromotionalOffer(
        product: Product,
        offerID: String,
        keyID: String,
        nonce: UUID,
        signature: String,
        timestamp: Int
    ) async -> PurchaseStatusBB {
        guard let subscription = product.subscription,
              let offer = subscription.promotionalOffers.first(where: { $0.id == offerID }) else {
            return .failed
        }
        
        let option = Product.PurchaseOption.promotionalOffer(
            offerID: offer.id ?? offerID,
            keyID: keyID,
            nonce: nonce,
            signature: signature.data(using: .utf8) ?? Data(),
            timestamp: timestamp
        )
        
        do {
            let result = try await product.purchase(options: [option])
            return try await handlePurchaseResult(result)
        } catch {
            return .failed
        }
    }
    
    private func handlePurchaseResult(_ result: Product.PurchaseResult) async throws -> PurchaseStatusBB {
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            purchasedProductIDs.insert(transaction.productID)
            await transaction.finish()
            return .success
        case .userCancelled:
            return .cancelled
        case .pending:
            return .pending
        @unknown default:
            return .failed
        }
    }
    
    func restorePurchases() async {
        try? await AppStore.sync()
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                purchasedProductIDs.insert(transaction.productID)
            }
        }
    }
    
    func restore() async {
        await restorePurchases()
    }
    
    func loadProducts() async {
        await fetchProducts()
    }
    
    private func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                purchasedProductIDs.insert(transaction.productID)
            }
        }
        entitlementsLoaded = true
    }
    
    private func observeTransactions() async {
        for await result in Transaction.updates {
            if case .verified(let transaction) = result {
                purchasedProductIDs.insert(transaction.productID)
                await transaction.finish()
            }
        }
    }
    
    private func listenForStoreIntents() async {
        if #available(iOS 16.4, *) {
            for await intent in PurchaseIntent.intents {
                pendingPurchaseIntent = intent
                _ = await purchase(intent.product)
            }
        }
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let safe):
            return safe
        case .unverified:
            throw StoreErrorBB.failedVerification
        }
    }
    
    nonisolated func paymentQueue(_ queue: SKPaymentQueue,
                                  shouldAddStorePayment payment: SKPayment,
                                  for product: SKProduct) -> Bool {
        return true
    }
}

extension StoreManagerBB {
    func hasAccess(to theme: ThemeModelBB) -> Bool {
        if !theme.isPremium { return true }
        let productID: String?
        switch theme.id {
        case "premium_theme_cyber_night": productID = "premium_theme_cyber_night"
        case "premium_theme_golden_hour": productID = "premium_theme_golden_hour"
        default: productID = nil
        }
        guard let pid = productID else { return false }
        return purchasedProductIDs.contains(pid)
    }
    
    func getProduct(for theme: ThemeModelBB) -> Product? {
        let productID: String?
        switch theme.id {
        case "premium_theme_cyber_night": productID = "premium_theme_cyber_night"
        case "premium_theme_golden_hour": productID = "premium_theme_golden_hour"
        default: productID = nil
        }
        guard let pid = productID else { return nil }
        return products.first { $0.id == pid }
    }
}

enum StoreErrorBB: Error {
    case failedVerification
}

enum PurchaseStatusBB {
    case success
    case pending
    case cancelled
    case failed
}
