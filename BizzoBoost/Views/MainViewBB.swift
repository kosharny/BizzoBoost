import SwiftUI

struct MainViewBB: View {
    @EnvironmentObject var viewModel: ViewModelBB

    @State private var showSplash = true

    var body: some View {
        if showSplash {
            SplashViewBB {
                withAnimation {
                    showSplash = false
                }
            }
        } else if viewModel.isOnboardingCompleted {
            ZStack(alignment: .bottom) {
                switch viewModel.activeTab {
                case .home:
                    HomeViewBB()
                case .journal:
                    JournalViewBB()
                case .activity:
                    ActivityViewBB()
                case .stat:
                    StatViewBB()
                case .settings:
                    SettingsViewBB()
                }

                TabBarBB()
            }
        } else {
            OnboardingContainerBB()
        }
    }
}

#Preview {
    MainViewBB().environmentObject(ViewModelBB()).environmentObject(StoreManagerBB())
}
