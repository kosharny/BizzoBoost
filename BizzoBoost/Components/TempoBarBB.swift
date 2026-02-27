import SwiftUI

struct TempoBarBB: View {
    @Binding var points: Int
    @State private var scale: CGFloat = 1.0
    @State private var quoteIndex: Int = 0

    private let quotes = [
        "Small steps every day.",
        "Consistency is key.",
        "Keep grinding, stay focused.",
        "One goal at a time.",
        "Build the habit, reap the reward."
    ]

    private var progress: CGFloat {
        let max = CGFloat(ActivityLevelBB.rhythmMaster.pointsRequired)
        return min(CGFloat(points) / max, 1.0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // Top Section: Image taking up top half with Overlay Quote
            ZStack(alignment: .bottom) {
                Image("onboarding_bg_1")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 120)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(colors: [.clear, .black.opacity(0.8)], startPoint: .top, endPoint: .bottom))
                    )
                
                Text(quotes[quoteIndex])
                    .font(.headline)
                    .italic()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding()
                    .animation(.easeInOut, value: quoteIndex)
            }
            .shadow(color: ThemeBB.neonMint.opacity(0.2), radius: 8)
            
            // Bottom Section: Title Text and Progress
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Tempo Bar")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(points) pts")
                        .font(.headline)
                        .foregroundColor(ThemeBB.neonMint)
                        .fontWeight(.semibold)
                }
                
                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(ThemeBB.primaryIndigo.opacity(0.5))
                            .frame(height: 30)
                        
                        RoundedRectangle(cornerRadius: 15)
                            .fill(ThemeBB.primaryGradient)
                            .frame(width: proxy.size.width * progress, height: 30)
                            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: progress)
                            .shadow(color: ThemeBB.neonMint.opacity(0.5), radius: 10)
                    }
                }
                .frame(height: 30)
            }
            .scaleEffect(scale)
            .onChange(of: points) { newValue in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                    scale = 1.05
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        scale = 1.0
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
                .shadow(color: .black.opacity(0.2), radius: 15)
        )
        .onAppear {
            let timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
                withAnimation {
                    quoteIndex = (quoteIndex + 1) % quotes.count
                }
            }
            RunLoop.main.add(timer, forMode: .common)
        }
    }
}

#Preview {
    TempoBarBB(points: .constant(500))
}
