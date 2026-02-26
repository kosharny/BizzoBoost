import SwiftUI

struct TempoBarBB: View {
    @Binding var points: Int
    @State private var scale: CGFloat = 1.0

    private var progress: CGFloat {
        let max = CGFloat(ActivityLevelBB.rhythmMaster.pointsRequired)
        return min(CGFloat(points) / max, 1.0)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Tempo Bar")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("\(points) pts")
                    .font(.subheadline)
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
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
                .shadow(color: .black.opacity(0.2), radius: 15)
        )
    }
}

#Preview {
    TempoBarBB(points: .constant(500))
}
