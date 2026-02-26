import SwiftUI
import AppTrackingTransparency
import Combine

struct SplashViewBB: View {
    @EnvironmentObject var viewModel: ViewModelBB
    var onFinish: () -> Void
    
    @State private var loadProgress: CGFloat = 0.0
    @State private var loadingPercentage: Int = 0
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            viewModel.currentTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack {
                Image(systemName: "bolt.shield.fill")
                    .font(.system(size: 90))
                    .foregroundColor(ThemeBB.neonMint)
                    .shadow(color: ThemeBB.neonMint.opacity(0.8), radius: 15)
                    .padding(.bottom, 10)
                
                Text("Bizzo Boost")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
                    .shadow(color: ThemeBB.neonMint.opacity(0.5), radius: 10)
                
                VStack(spacing: 8) {
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 250, height: 8)
                        
                        Capsule()
                            .fill(ThemeBB.primaryGradient)
                            .frame(width: 250 * loadProgress, height: 8)
                    }
                    
                    Text("\(loadingPercentage)%")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.top, 40)
            }
        }
        .onReceive(timer) { _ in
            if loadProgress < 1.0 {
                withAnimation(.linear(duration: 0.02)) {
                    loadProgress += 0.015
                    loadingPercentage = min(Int(loadProgress * 100), 100)
                }
            } else {
                timer.upstream.connect().cancel()
                ATTrackingManager.requestTrackingAuthorization { _ in
                    DispatchQueue.main.async {
                        onFinish()
                    }
                }
            }
        }
    }
}

#Preview {
    SplashViewBB(onFinish: {}).environmentObject(ViewModelBB())
}
