import SwiftUI
import AudioToolbox

struct GoalCardBB: View {
    var goal: GoalModelBB
    var onToggle: () -> Void
    @State private var bounce: Bool = false

    var body: some View {
        HStack(spacing: 16) {
            Button {
                let impact = UIImpactFeedbackGenerator(style: .rigid)
                impact.impactOccurred()
                AudioServicesPlaySystemSound(1520) // Pop sound effect
                
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                    bounce.toggle()
                }
                onToggle()
            } label: {
                ZStack {
                    Circle()
                        .strokeBorder(goal.isCompleted ? ThemeBB.neonMint : .white.opacity(0.5), lineWidth: 2)
                        .frame(width: 30, height: 30)
                    
                    if goal.isCompleted {
                        Circle()
                            .fill(ThemeBB.neonMint)
                            .frame(width: 20, height: 20)
                            .transition(.scale)
                    }
                }
            }
            .scaleEffect(bounce ? 1.2 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.5), value: bounce)
            .onChange(of: bounce) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    bounce = false
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(goal.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(goal.isCompleted ? .white.opacity(0.5) : .white)
                    .strikethrough(goal.isCompleted)
                
                Text(goal.category)
                    .font(.caption)
                    .foregroundColor(ThemeBB.accentGlow)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(ThemeBB.accentGlow.opacity(0.2))
                    .clipShape(Capsule())
            }
            
            Spacer()
            
            Text("+\(goal.points)")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(goal.isCompleted ? .white.opacity(0.3) : ThemeBB.premiumGold)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(goal.isCompleted ? ThemeBB.primaryIndigo.opacity(0.3) : ThemeBB.primaryIndigo.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(goal.isCompleted ? ThemeBB.neonMint.opacity(0.3) : .clear, lineWidth: 1)
                )
        }
        .opacity(goal.isCompleted ? 0.7 : 1.0)
    }
}

#Preview {
    GoalCardBB(goal: GoalModelBB(title: "Read", category: "Study", date: Date(), isCompleted: false, points: 50), onToggle: {})
}
