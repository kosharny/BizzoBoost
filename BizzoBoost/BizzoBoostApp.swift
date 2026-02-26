import SwiftUI

@main
struct BizzoBoostApp: App {
    @StateObject private var viewModel = ViewModelBB()
    @StateObject private var storeManager = StoreManagerBB.shared

    var body: some Scene {
        WindowGroup {
            MainViewBB()
                .environmentObject(viewModel)
                .environmentObject(storeManager)
        }
    }
}
