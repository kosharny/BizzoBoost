import SwiftUI

struct OnboardingOneBB: View {
    var onContinue: () -> Void

    var body: some View {
        ZStack {
            Image("onboarding_bg_1")
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
                    Text("Focus & Energy")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("Turn your daily goals into a gamified experience. Boost your energy every day.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal)
                    
                    Button(action: onContinue) {
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(ThemeBB.primaryGradient)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: ThemeBB.electricBlue.opacity(0.5), radius: 10)
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
                                .stroke(ThemeBB.neonMint.opacity(0.3), lineWidth: 1)
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
    OnboardingOneBB(onContinue: {})
}
