import SwiftUI

struct VolumetricBackgroundBB: View {
    var theme: ThemeModelBB
    
    @State private var animateOrb1 = false
    @State private var animateOrb2 = false
    @State private var animateOrb3 = false

    var body: some View {
        ZStack {
            // Base Gradient
            theme.backgroundGradient
                .ignoresSafeArea()
            
            // Orb 1 (Top Left)
            GeometryReader { proxy in
                Circle()
                    .fill(Color(hex: theme.colorHex).opacity(0.3))
                    .frame(width: proxy.size.width * 0.8, height: proxy.size.width * 0.8)
                    .blur(radius: 80)
                    .offset(x: animateOrb1 ? -50 : 50, y: animateOrb1 ? -100 : 0)
                    .animation(Animation.easeInOut(duration: 8).repeatForever(autoreverses: true), value: animateOrb1)
                    .onAppear { animateOrb1 = true }
            }
            .ignoresSafeArea()
            
            // Orb 2 (Bottom Right)
            GeometryReader { proxy in
                Circle()
                    .fill(ThemeBB.premiumGold.opacity(0.2))
                    .frame(width: proxy.size.width * 0.9, height: proxy.size.width * 0.9)
                    .blur(radius: 100)
                    .offset(x: animateOrb2 ? proxy.size.width * 0.5 : proxy.size.width * 0.2,
                            y: animateOrb2 ? proxy.size.height * 0.6 : proxy.size.height * 0.8)
                    .animation(Animation.easeInOut(duration: 10).repeatForever(autoreverses: true), value: animateOrb2)
                    .onAppear { animateOrb2 = true }
            }
            .ignoresSafeArea()
            
            // Orb 3 (Center subtle pulse)
            GeometryReader { proxy in
                Capsule()
                    .fill(ThemeBB.neonMint.opacity(0.15))
                    .frame(width: proxy.size.width * 1.5, height: proxy.size.height * 0.4)
                    .rotationEffect(.degrees(animateOrb3 ? 45 : 25))
                    .blur(radius: 120)
                    .offset(x: -proxy.size.width * 0.2, y: proxy.size.height * 0.3)
                    .animation(Animation.easeInOut(duration: 12).repeatForever(autoreverses: true), value: animateOrb3)
                    .onAppear { animateOrb3 = true }
            }
            .ignoresSafeArea()
        }
    }
}
