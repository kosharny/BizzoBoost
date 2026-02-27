import SwiftUI

struct JournalViewBB: View {
    @EnvironmentObject var viewModel: ViewModelBB
    @State private var selectedGoal: GoalModelBB?
    @State private var showAddThought: Bool = false

    var body: some View {
        ZStack {
            viewModel.currentTheme.backgroundGradient
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Text("Journal")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(0..<14) { i in
                            let date = Calendar.current.date(byAdding: .day, value: -i, to: Date())!
                            let isToday = i == 0
                            VStack {
                                Text(date.formatted(.dateTime.weekday(.short)))
                                    .font(.caption)
                                    .foregroundColor(isToday ? ThemeBB.neonMint : .white.opacity(0.6))
                                Text(date.formatted(.dateTime.day()))
                                    .font(.headline)
                                    .foregroundColor(isToday ? ThemeBB.neonMint : .white)
                            }
                            .padding()
                            .background {
                                if isToday {
                                    ThemeBB.neonMint.opacity(0.2)
                                } else {
                                    Rectangle().fill(.ultraThinMaterial)
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding()
                }

                HStack {
                    Text("Archive")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                    Spacer()
                    Button {
                        showAddThought = true
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add Thought")
                        }
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(ThemeBB.primaryIndigo)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(ThemeBB.neonMint)
                        .clipShape(Capsule())
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)

                ScrollView {
                    
                    
                    let completed = viewModel.completedGoals()
                    if completed.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "book.closed")
                                .font(.system(size: 80))
                                .foregroundColor(.white.opacity(0.3))
                            Text("No history yet")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding(.top, 50)
                    } else {
                        VStack(spacing: 16) {
                            ForEach(completed) { goal in
                                    VStack(alignment: .leading, spacing: 12) {
                                        HStack(alignment: .top) {
                                            VStack(alignment: .leading, spacing: 6) {
                                                Text(goal.title)
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                                
                                                HStack {
                                                    Text(goal.category)
                                                        .font(.caption)
                                                        .foregroundColor(ThemeBB.accentGlow)
                                                    
                                                    if goal.photoData != nil {
                                                        Image(systemName: "photo")
                                                            .font(.caption)
                                                            .foregroundColor(ThemeBB.neonMint)
                                                    }
                                                }
                                            }
                                            Spacer()
                                            VStack(alignment: .trailing, spacing: 6) {
                                                Text(goal.date, style: .date)
                                                    .font(.caption)
                                                    .foregroundColor(.white.opacity(0.6))
                                                Text("+\(goal.points)")
                                                    .font(.subheadline)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(ThemeBB.premiumGold)
                                            }
                                        }
                                        
                                        if let note = goal.note, !note.isEmpty {
                                            Text(note)
                                                .font(.subheadline)
                                                .foregroundColor(.white.opacity(0.9))
                                                .lineLimit(3)
                                                .multilineTextAlignment(.leading)
                                        }
                                    }
                                    .padding()
                                    .background(.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 100)
                    }
                }
                
                if viewModel.completedGoals().isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(ThemeBB.premiumGold)
                            Text("How it works")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        Text("This is your history. Tap any completed goal below to attach a personal note or a photo to preserve your memories of achieving it.")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    .background(ThemeBB.premiumGold.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(ThemeBB.premiumGold.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    .padding(.bottom, 110)
                }
            }
        }
        .sheet(item: $selectedGoal) { goal in
            JournalDetailViewBB(goal: goal)
        }
        .sheet(isPresented: $showAddThought) {
            AddThoughtViewBB()
        }
    }
}

#Preview {
    JournalViewBB().environmentObject(ViewModelBB())
}
