import SwiftUI

struct ParticleModifierBB: ViewModifier {
    @State private var time = 0.0
    @State private var scale = 0.1
    let emit: Bool

    func body(content: Content) -> some View {
        ZStack {
            if emit {
                Canvas { context, size in
                    for i in 0..<8 {
                        let angle = Double(i) * (Double.pi / 4)
                        let distance = time * 40
                        let x = size.width / 2 + CGFloat(cos(angle)) * CGFloat(distance)
                        let y = size.height / 2 + CGFloat(sin(angle)) * CGFloat(distance)
                        
                        var path = Path()
                        path.addArc(center: CGPoint(x: x, y: y), radius: 4, startAngle: .zero, endAngle: .degrees(360), clockwise: true)
                        context.fill(path, with: .color(ThemeBB.neonMint))
                        
                        var path2 = Path()
                        path2.addArc(center: CGPoint(x: x, y: y), radius: 2, startAngle: .zero, endAngle: .degrees(360), clockwise: true)
                        context.fill(path2, with: .color(ThemeBB.premiumGold))
                    }
                }
                .frame(width: 100, height: 100)
                .opacity(1.0 - time)
                .scaleEffect(scale)
                .onAppear {
                    time = 0.0
                    scale = 0.1
                    withAnimation(.easeOut(duration: 0.6)) {
                        time = 1.0
                        scale = 1.5
                    }
                }
            }
            content
        }
    }
}

extension View {
    func emitParticles(if emit: Bool) -> some View {
        self.modifier(ParticleModifierBB(emit: emit))
    }
}
