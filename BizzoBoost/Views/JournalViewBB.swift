import SwiftUI

struct JournalViewBB: View {
    @EnvironmentObject var viewModel: ViewModelBB
    @State private var selectedGoal: GoalModelBB?
    @State private var inlineThought: String = ""
    @State private var selectedDate: Date = Date()

    private var totalEntries: Int {
        viewModel.completedGoals().count
    }

    var body: some View {
        ZStack {
            VolumetricBackgroundBB(theme: viewModel.currentTheme)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header with stats
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Journal")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text("Reflect on your journey")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(totalEntries)")
                            .font(.system(size: 26, weight: .heavy, design: .rounded))
                            .foregroundColor(ThemeBB.neonMint)
                        Text("Entries")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.6))
                            .textCase(.uppercase)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 12)

                // Calendar Strip
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(0..<14) { i in
                            let date = Calendar.current.date(byAdding: .day, value: -i, to: Date())!
                            let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)
                            
                            Button {
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedDate = date
                                }
                            } label: {
                                VStack(spacing: 8) {
                                    Text(date.formatted(.dateTime.weekday(.short)))
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(isSelected ? ThemeBB.primaryIndigo : .white.opacity(0.6))
                                    Text(date.formatted(.dateTime.day()))
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(isSelected ? ThemeBB.primaryIndigo : .white)
                                }
                                .frame(width: 65, height: 85)
                                .background {
                                    if isSelected {
                                        RoundedRectangle(cornerRadius: 22)
                                            .fill(ThemeBB.neonMint)
                                            .shadow(color: ThemeBB.neonMint.opacity(0.6), radius: 10, y: 4)
                                    } else {
                                        RoundedRectangle(cornerRadius: 22)
                                            .fill(.ultraThinMaterial)
                                            .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color.white.opacity(0.2), lineWidth: 1))
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        // Premium Quick Log
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(ThemeBB.premiumGold)
                                    .font(.title3)
                                Text("Quick Log")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.black.opacity(0.2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(ThemeBB.premiumGold.opacity(0.3), lineWidth: 1)
                                    )
                                
                                TextEditor(text: $inlineThought)
                                    .frame(height: 100)
                                    .padding(12)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.clear)
                                    .foregroundColor(.white)
                                    .font(.body)
                                
                                if inlineThought.isEmpty {
                                    Text("What's on your mind today?")
                                        .foregroundColor(.white.opacity(0.4))
                                        .padding(.top, 20)
                                        .padding(.leading, 16)
                                        .allowsHitTesting(false)
                                }
                            }
                            
                            HStack {
                                Spacer()
                                Button {
                                    if !inlineThought.isEmpty {
                                        let impact = UIImpactFeedbackGenerator(style: .medium)
                                        impact.impactOccurred()
                                        let newID = viewModel.addGoal(title: "Journal Entry", category: "Thoughts", note: inlineThought, photoData: nil)
                                        viewModel.toggleGoalCompletion(id: newID)
                                        withAnimation {
                                            inlineThought = ""
                                        }
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    }
                                } label: {
                                    Text("Save Entry")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(inlineThought.isEmpty ? .white.opacity(0.5) : ThemeBB.primaryIndigo)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 14)
                                        .background(inlineThought.isEmpty ? Color.white.opacity(0.1) : ThemeBB.premiumGold)
                                        .clipShape(Capsule())
                                        .shadow(color: inlineThought.isEmpty ? .clear : ThemeBB.premiumGold.opacity(0.5), radius: 8, y: 4)
                                }
                                .disabled(inlineThought.isEmpty)
                            }
                        }
                        .padding(.top, 20)
                        .padding(20)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.white.opacity(0.1), lineWidth: 1))
                        
                        // Timeline
                        let completed = viewModel.completedGoals().filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
                        if completed.isEmpty {
                            VStack(spacing: 20) {
                                Image(systemName: "book.pages")
                                    .font(.system(size: 64))
                                    .foregroundColor(.white.opacity(0.3))
                                Text("No entries for this date.")
                                    .font(.headline)
                                    .foregroundColor(.white.opacity(0.5))
                                Text("Complete a goal or add a quick log above to record your thoughts for today.")
                                    .font(.subheadline)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white.opacity(0.4))
                                    .padding(.horizontal, 40)
                            }
                            .padding(.top, 60)
                            .frame(maxWidth: .infinity)
                        } else {
                            VStack(alignment: .leading, spacing: 0) {
                                HStack {
                                    Text("Timeline")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding(.bottom, 20)
                                
                                ForEach(Array(completed.enumerated()), id: \.element.id) { index, goal in
                                    HStack(alignment: .top, spacing: 16) {
                                        // Timeline Graphic
                                        VStack(spacing: 0) {
                                            Circle()
                                                .fill(ThemeBB.neonMint)
                                                .frame(width: 14, height: 14)
                                                .shadow(color: ThemeBB.neonMint.opacity(0.8), radius: 6, y: 0)
                                                .padding(.top, 24)
                                            
                                            if index < completed.count - 1 {
                                                Rectangle()
                                                    .fill(
                                                        LinearGradient(colors: [ThemeBB.neonMint.opacity(0.6), ThemeBB.neonMint.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                                                    )
                                                    .frame(width: 2)
                                            }
                                        }
                                        .frame(width: 20)
                                        
                                        // Entry Card
                                        Button {
                                            selectedGoal = goal
                                        } label: {
                                            VStack(alignment: .leading, spacing: 12) {
                                                HStack(alignment: .top) {
                                                    VStack(alignment: .leading, spacing: 6) {
                                                        Text(goal.title)
                                                            .font(.headline)
                                                            .foregroundColor(.white)
                                                            .multilineTextAlignment(.leading)
                                                        
                                                        HStack(spacing: 6) {
                                                            Text(goal.category)
                                                                .font(.caption2)
                                                                .fontWeight(.bold)
                                                                .foregroundColor(.white)
                                                                .padding(.horizontal, 10)
                                                                .padding(.vertical, 4)
                                                                .background(ThemeBB.primaryIndigo)
                                                                .clipShape(Capsule())
                                                            
                                                            if goal.photoData != nil {
                                                                Image(systemName: "photo")
                                                                    .font(.caption)
                                                                    .foregroundColor(ThemeBB.neonMint)
                                                            }
                                                        }
                                                    }
                                                    Spacer()
                                                    VStack(alignment: .trailing, spacing: 4) {
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
                                            .padding(16)
                                            .background(.ultraThinMaterial)
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.15), lineWidth: 1))
                                        }
                                        .buttonStyle(.plain)
                                        .padding(.bottom, index < completed.count - 1 ? 24 : 0)
                                    }
                                }
                            }
                        }
                        
                        // How it works card
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
                            Text("This is your history. Tap any completed goal in your timeline to attach a personal note or a photo to preserve your memories of achieving it.")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(20)
                        .background(ThemeBB.premiumGold.opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(ThemeBB.premiumGold.opacity(0.4), lineWidth: 1)
                        )
                        .padding(.top, 40)
                        
                        Spacer(minLength: 120)
                    }
                    .padding(.horizontal, 20)
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
