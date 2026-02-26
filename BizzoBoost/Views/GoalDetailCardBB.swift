import SwiftUI
import AudioToolbox

struct GoalDetailCardBB: View {
    let goal: GoalModelBB
    var onComplete: () -> Void
    var onClose: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onClose()
                }

            VStack(spacing: 20) {
                HStack {
                    Text(goal.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button {
                        onClose()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.6))
                    }
                }

                HStack {
                    Text(goal.category)
                        .font(.subheadline)
                        .foregroundColor(ThemeBB.accentGlow)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(ThemeBB.accentGlow.opacity(0.2))
                        .clipShape(Capsule())
                    Spacer()
                    Text(goal.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
                
                if let note = goal.note, !note.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                        
                        Text(note)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.9))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                if let photoData = goal.photoData, let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Button {
                    let impact = UIImpactFeedbackGenerator(style: .rigid)
                    impact.impactOccurred()
                    AudioServicesPlaySystemSound(1520) // Pop sound effect
                    onComplete()
                    onClose()
                } label: {
                    Text(goal.isCompleted ? "Completed" : "Complete Boost")
                        .font(.headline)
                        .foregroundColor(goal.isCompleted ? .white.opacity(0.5) : ThemeBB.primaryIndigo)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(goal.isCompleted ? Color.white.opacity(0.1) : ThemeBB.neonMint)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .disabled(goal.isCompleted)
                .padding(.top, 10)
            }
            .padding(24)
            .background(ThemeBB.primaryIndigo)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 30)
        }
    }
}

#Preview {
    GoalDetailCardBB(goal: GoalModelBB(title: "Morning Run", category: "Sport", date: Date(), isCompleted: true, points: 50, note: "Ran 5km today! Felt great.", photoData: nil), onComplete: {}) {}
}
