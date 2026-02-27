import SwiftUI

struct HomeViewBB: View {
    @EnvironmentObject var viewModel: ViewModelBB
    @State private var showingAddGoal = false
    @State private var showParticles = false
    @State private var selectedGoal: GoalModelBB?

    var body: some View {
        ZStack {
            viewModel.currentTheme.backgroundGradient
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

                TempoBarBB(points: $viewModel.points)
                    .padding()
                    .emitParticles(if: showParticles)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        let todaysGoals = viewModel.todaysGoals()
                        if todaysGoals.isEmpty {
                                VStack(spacing: 8) {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 32))
                                        .foregroundColor(ThemeBB.premiumGold)
                                        .padding(.bottom, 4)
                                    
                                    Text("Ready to Boost?")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Text("Every great journey begins with a single step. Tap Boost below to add your first goal and start building your productivity streak!")
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
                        } else {
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
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100)
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
