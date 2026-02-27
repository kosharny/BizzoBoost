import SwiftUI

struct JournalViewBB: View {
    @EnvironmentObject var viewModel: ViewModelBB
    @State private var selectedGoal: GoalModelBB?
    @State private var inlineThought: String = ""

    var body: some View {
        ZStack {
            VolumetricBackgroundBB(theme: viewModel.currentTheme)
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
                            .padding(.vertical, 24)
                            .padding(.horizontal, 16)
                            .background {
                                if isToday {
                                    ThemeBB.neonMint.opacity(0.2)
                                } else {
                                    Rectangle().fill(.ultraThinMaterial)
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }
                    .padding()
                }

                HStack {
                    Text("Archive")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 10)

                ScrollView {
                    
                    
                    // Inline Add Thought Card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "square.and.pencil")
                                .foregroundColor(ThemeBB.neonMint)
                            Text("Quick Log")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $inlineThought)
                                .frame(height: 80)
                                .padding(8)
                                .scrollContentBackground(.hidden)
                                .background(Color.white.opacity(0.1))
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            if inlineThought.isEmpty {
                                Text("What's on your mind today?")
                                    .foregroundColor(.white.opacity(0.4))
                                    .padding(.top, 16)
                                    .padding(.leading, 12)
                                    .allowsHitTesting(false)
                            }
                        }
                        
                        Button {
                            if !inlineThought.isEmpty {
                                let newID = viewModel.addGoal(title: "Journal Entry", category: "Thoughts", note: inlineThought, photoData: nil)
                                viewModel.toggleGoalCompletion(id: newID) // Auto complete specific goal
                                inlineThought = ""
                            }
                        } label: {
                            Text("Save Thought")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(inlineThought.isEmpty ? Color.gray.opacity(0.5) : ThemeBB.electricBlue)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .disabled(inlineThought.isEmpty)
                    }
                    .padding()
                    .background(ThemeBB.primaryIndigo.opacity(0.6))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    
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
                    }
                    
                    // Permanent How it works card at bottom of scroll (moved outside else wrapper)
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "lightbulb.fill")
                                .font(.title2)
                                .foregroundColor(ThemeBB.premiumGold)
                            Text("How it works")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        Text("This is your history. Tap any completed goal above to attach a personal note or a photo to preserve your memories of achieving it.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    .background(ThemeBB.premiumGold.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(ThemeBB.premiumGold.opacity(0.4), lineWidth: 1)
                    )
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    Spacer(minLength: 100)
                }
                
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .sheet(item: $selectedGoal) { goal in
            JournalDetailViewBB(goal: goal)
        }
    }
}

#Preview {
    JournalViewBB().environmentObject(ViewModelBB())
}
