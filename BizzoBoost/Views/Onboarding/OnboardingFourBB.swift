import SwiftUI

struct OnboardingFourBB: View {
    var onFinish: () -> Void

    var body: some View {
        ZStack {
            Image("onboarding_bg_4")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .clipped()
                .ignoresSafeArea()
            
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack {
                Spacer()
                
                VStack(spacing: 16) {
                    Text("Limitless Growth")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("Unlock your full potential starting today. Let's make it happen!")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal)
                    
                    Button(action: onFinish) {
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(ThemeBB.primaryIndigo)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(ThemeBB.premiumGold)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: ThemeBB.premiumGold.opacity(0.5), radius: 10)
                    }
                    .padding(.top, 16)
                }
                .padding(24)
                .background {
                    RoundedRectangle(cornerRadius: 32)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.3), radius: 20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(ThemeBB.premiumGold.opacity(0.5), lineWidth: 1)
                        )
                }
                .padding(20)
                .padding(.bottom, 20)
            }
            .frame(width: UIScreen.main.bounds.width)
        }
    }
}

#Preview {
    OnboardingFourBB(onFinish: {})
}
