import SwiftUI

struct AboutViewBB: View {
    @EnvironmentObject var viewModel: ViewModelBB
    var body: some View {
        ZStack {
            viewModel.currentTheme.backgroundGradient
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "bolt.shield.fill")
                    .font(.system(size: 90))
                    .foregroundColor(ThemeBB.neonMint)
                    .shadow(color: ThemeBB.neonMint.opacity(0.8), radius: 15)
                    .padding(.bottom, 10)
                
                Text("Bizzo Boost")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Version 1.0.0")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.6))
                
                Text("Bizzo Boost is your personal gamified daily tracker. Turn your daily habits, study routines, and sports activities into a rewarding game, and start building your productivity streak today!")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, 32)
                    .padding(.top, 20)
                
                Spacer()
            }
            .padding(.top, 60)
        }
        .navigationTitle("About App")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    AboutViewBB().environmentObject(ViewModelBB())
}
