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

            VStack(alignment: .leading, spacing: 6) {
                Text(goal.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(goal.isCompleted ? .white.opacity(0.5) : .white)
                    .strikethrough(goal.isCompleted)
                
                Text(goal.category)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(ThemeBB.accentGlow)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(ThemeBB.accentGlow.opacity(0.2))
                    .clipShape(Capsule())
            }
            
            Spacer()
            
            Text("+\(goal.points)")
                .font(.title3)
                .fontWeight(.heavy)
                .foregroundColor(goal.isCompleted ? .white.opacity(0.3) : ThemeBB.premiumGold)
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
        .background {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    goal.isCompleted
                        ? AnyShapeStyle(ThemeBB.primaryIndigo.opacity(0.4))
                        : AnyShapeStyle(LinearGradient(
                            colors: [ThemeBB.electricBlue.opacity(0.4), ThemeBB.neonMint.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                )
                .shadow(color: ThemeBB.neonMint.opacity(goal.isCompleted ? 0 : 0.15), radius: 10, y: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            goal.isCompleted
                                ? ThemeBB.neonMint.opacity(0.3)
                                : ThemeBB.neonMint.opacity(0.5),
                            lineWidth: goal.isCompleted ? 1 : 1.5
                        )
                )
        }
        .opacity(goal.isCompleted ? 0.8 : 1.0)
    }
}

#Preview {
    GoalCardBB(goal: GoalModelBB(title: "Read", category: "Study", date: Date(), isCompleted: false, points: 50), onToggle: {})
}
