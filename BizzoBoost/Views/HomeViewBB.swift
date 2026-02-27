import SwiftUI

struct HomeViewBB: View {
    @EnvironmentObject var viewModel: ViewModelBB
    @State private var showingAddGoal = false
    @State private var showParticles = false
    @State private var showInfographic = false
    @State private var showInsights = false
    @State private var selectedGoal: GoalModelBB?
    @State private var selectedMood: Int? = nil

    private var hydrationKey: String {
        let f = DateFormatter(); f.dateFormat = "yyyy-MM-dd"
        return "hydration_" + f.string(from: Date())
    }
    @State private var glasses: Int = 0

    private let affirmations = [
        "You are capable of amazing things.",
        "Small steps lead to big changes.",
        "Progress, not perfection.",
        "Your effort today builds tomorrow.",
        "Consistency is your superpower.",
        "Believe in the process.",
        "Every day is a fresh start.",
        "You have the strength to succeed.",
        "Stay focused and trust yourself.",
        "Great things take time — keep going."
    ]
    private var todayAffirmation: String {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return affirmations[dayOfYear % affirmations.count]
    }

    var body: some View {
        ZStack {
            VolumetricBackgroundBB(theme: viewModel.currentTheme)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Today")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text(Date(), style: .date)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        TempoBarBB(points: $viewModel.points)
                            .padding(.top, 8)
                            .emitParticles(if: showParticles)
                        
                        // Daily Affirmation Card
                        HStack(spacing: 12) {
                            Image(systemName: "quote.opening")
                                .font(.title2)
                                .foregroundColor(ThemeBB.premiumGold)
                            Text(todayAffirmation)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }
                        .padding()
                        .background(LinearGradient(
                            colors: [ThemeBB.premiumGold.opacity(0.15), ThemeBB.electricBlue.opacity(0.1)],
                            startPoint: .leading, endPoint: .trailing))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(RoundedRectangle(cornerRadius: 16)
                            .stroke(ThemeBB.premiumGold.opacity(0.3), lineWidth: 1))
                        
                        // Hydration Tracker
                        HStack {
                            Image(systemName: "drop.fill")
                                .foregroundColor(ThemeBB.electricBlue)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Hydration")
                                    .font(.subheadline).fontWeight(.semibold).foregroundColor(.white)
                                HStack(spacing: 4) {
                                    ForEach(0..<8, id: \.self) { i in
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(i < glasses ? ThemeBB.electricBlue : Color.white.opacity(0.1))
                                            .frame(width: 20, height: 10)
                                    }
                                }
                            }
                            Spacer()
                            HStack(spacing: 8) {
                                Button {
                                    if glasses > 0 { glasses -= 1; UserDefaults.standard.set(glasses, forKey: hydrationKey) }
                                } label: {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.title3).foregroundColor(.white.opacity(0.4))
                                }
                                Text("\(glasses)/8")
                                    .font(.subheadline).fontWeight(.bold).foregroundColor(.white)
                                Button {
                                    if glasses < 8 { glasses += 1; UserDefaults.standard.set(glasses, forKey: hydrationKey) }
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title3).foregroundColor(ThemeBB.electricBlue)
                                }
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(RoundedRectangle(cornerRadius: 16)
                            .stroke(ThemeBB.electricBlue.opacity(0.3), lineWidth: 1))
                        .onAppear {
                            glasses = UserDefaults.standard.integer(forKey: hydrationKey)
                        }
                        
                        // Daily Mood Check-in Card
                        let moodEmojis = ["😞", "😕", "😐", "🙂", "😁"]
                        let moodLabels = ["Rough", "Meh", "Okay", "Good", "Great"]
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "face.smiling")
                                    .foregroundColor(ThemeBB.neonMint)
                                Text("How are you feeling today?")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                Spacer()
                                if selectedMood != nil {
                                    Text("Logged ✓")
                                        .font(.caption)
                                        .foregroundColor(ThemeBB.neonMint)
                                }
                            }
                            HStack(spacing: 8) {
                                ForEach(0..<moodEmojis.count, id: \.self) { i in
                                    Button {
                                        guard selectedMood == nil else { return }
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                            selectedMood = i
                                            viewModel.logMood(index: i, emoji: moodEmojis[i], label: moodLabels[i])
                                        }
                                    } label: {
                                        VStack(spacing: 6) {
                                            AssetMapBB.moodImage(for: i)
                                                .frame(width: 36, height: 36)
                                            Text(moodLabels[i])
                                                .font(.system(size: 9, weight: .semibold))
                                                .foregroundColor(selectedMood == i ? ThemeBB.neonMint : .white.opacity(0.4))
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(selectedMood == i
                                                    ? ThemeBB.neonMint.opacity(0.2)
                                                    : Color.white.opacity(0.05))
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(selectedMood == i ? ThemeBB.neonMint : Color.clear, lineWidth: 1.5)
                                        )
                                        .scaleEffect(selectedMood == i ? 1.08 : 1.0)
                                        .opacity(selectedMood != nil && selectedMood != i ? 0.4 : 1.0)
                                    }
                                    .disabled(selectedMood != nil && selectedMood != i)
                                }
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(ThemeBB.neonMint.opacity(0.2), lineWidth: 1))
                        .onAppear {
                            selectedMood = viewModel.todaysMoodIndex()
                        }

                        let todaysGoals = viewModel.todaysGoals()
                        
                        ForEach(todaysGoals) { goal in
                            GoalCardBB(goal: goal) {
                                viewModel.toggleGoalCompletion(id: goal.id)
                                if !goal.isCompleted {
                                    showParticles = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        showParticles = false
                                    }
                                }
                            }
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedGoal = goal
                                }
                            }
                        }
                        
                        HStack(spacing: 12) {
                            // My Focus Insights
                            Button { showInsights = true } label: {
                                ZStack(alignment: .topLeading) {
                                    RoundedRectangle(cornerRadius: 18)
                                        .fill(.ultraThinMaterial)
                                        .overlay(RoundedRectangle(cornerRadius: 18)
                                            .stroke(ThemeBB.neonMint.opacity(0.35), lineWidth: 1))
                                    
                                    VStack(alignment: .leading, spacing: 6) {
                                        Image(systemName: "brain.head.profile")
                                            .font(.title2)
                                            .foregroundColor(ThemeBB.neonMint)
                                        Spacer()
                                        Text("My Focus\nInsights")
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundColor(.white)
                                            .lineLimit(2)
                                            .minimumScaleFactor(0.8)
                                            .fixedSize(horizontal: false, vertical: true)
                                        Text("Productivity")
                                            .font(.system(size: 10))
                                            .foregroundColor(.white.opacity(0.45))
                                    }
                                    .padding(12)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 120)
                            }
                            
                            // Global Goal Trends
                            Button { showInfographic = true } label: {
                                ZStack(alignment: .topLeading) {
                                    RoundedRectangle(cornerRadius: 18)
                                        .fill(.ultraThinMaterial)
                                        .overlay(RoundedRectangle(cornerRadius: 18)
                                            .stroke(ThemeBB.premiumGold.opacity(0.35), lineWidth: 1))
                                    
                                    VStack(alignment: .leading, spacing: 6) {
                                        Image(systemName: "chart.bar.fill")
                                            .font(.title2)
                                            .foregroundColor(ThemeBB.premiumGold)
                                        Spacer()
                                        Text("Global Goal\nTrends")
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundColor(.white)
                                            .lineLimit(2)
                                            .minimumScaleFactor(0.8)
                                            .fixedSize(horizontal: false, vertical: true)
                                        Text("Community")
                                            .font(.system(size: 10))
                                            .foregroundColor(.white.opacity(0.45))
                                    }
                                    .padding(12)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 120)
                            }
                        }
                        .padding(.bottom, 4)
                        
                        // Ready to Boost card permanently at the bottom
                        VStack(spacing: 8) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 32))
                                .foregroundColor(ThemeBB.premiumGold)
                                .padding(.bottom, 4)
                            
                            Text("Ready to Boost?")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Every great journey begins with a single step. Tap Boost below to add a new goal and build your streak!")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.horizontal, 8)
                        }
                        .padding(16)
                        .background {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(.ultraThinMaterial)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(ThemeBB.primaryIndigo.opacity(0.5), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100)
                    
                    Spacer(minLength: 100)
                }
            }

            VStack {
                Spacer()
                Button {
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                    showingAddGoal = true
                } label: {
                    HStack {
                        Image(systemName: "bolt.fill")
                        Text("Boost")
                    }
                    .font(.headline)
                    .foregroundColor(ThemeBB.primaryIndigo)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 16)
                    .background(ThemeBB.neonMint)
                    .clipShape(Capsule())
                    .shadow(color: ThemeBB.neonMint.opacity(0.6), radius: 15, y: 5)
                }
                .padding(.bottom, 100)
            }
        }
        .sheet(isPresented: $showingAddGoal) {
            AddGoalViewBB()
        }
        .sheet(isPresented: $showInfographic) {
            PopularGoalsInfoViewBB()
        }
        .sheet(isPresented: $showInsights) {
            ProductivityInsightsViewBB()
        }
        
        if let goal = selectedGoal {
            GoalDetailCardBB(goal: goal) {
                viewModel.toggleGoalCompletion(id: goal.id)
                if !goal.isCompleted {
                    showParticles = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        showParticles = false
                    }
                }
            } onClose: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedGoal = nil
                }
            }
            .transition(.opacity.combined(with: .scale(scale: 0.9)))
            .zIndex(2)
        }
    }
}

#Preview {
    HomeViewBB().environmentObject(ViewModelBB())
}
