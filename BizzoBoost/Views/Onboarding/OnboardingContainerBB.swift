import SwiftUI
import AppTrackingTransparency

struct OnboardingContainerBB: View {
    @EnvironmentObject var viewModel: ViewModelBB
    @State private var currentStep = 0

    var body: some View {
        ZStack {
            if currentStep == 0 {
                OnboardingOneBB {
                    withAnimation { currentStep = 1 }
                }
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            } else if currentStep == 1 {
                OnboardingTwoBB {
                    withAnimation { currentStep = 2 }
                }
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            } else if currentStep == 2 {
                OnboardingThreeBB {
                    withAnimation { currentStep = 3 }
                }
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            } else if currentStep == 3 {
                OnboardingFourBB {
                    viewModel.completeOnboarding()
                }
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            }
        }
    }
}

#Preview {
    OnboardingContainerBB().environmentObject(ViewModelBB())
}
