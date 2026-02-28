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

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good Morning!"
        case 12..<17: return "Good Afternoon!"
        case 17..<22: return "Good Evening!"
        default: return "Good Night!"
        }
    }

    var body: some View {
        ZStack {
            VolumetricBackgroundBB(theme: viewModel.currentTheme)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(greeting)
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text(Date().formatted(date: .complete, time: .omitted))
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 12)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        TempoBarBB(points: $viewModel.points)
                            .padding(.top, 8)
                            .emitParticles(if: showParticles)
                        
                        // Affirmation Banner
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(ThemeBB.premiumGold.opacity(0.2))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "sparkles")
                                    .font(.title3)
                                    .foregroundColor(ThemeBB.premiumGold)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Daily Affirmation")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(ThemeBB.premiumGold)
                                    .textCase(.uppercase)
                                
                                Text(todayAffirmation)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Spacer()
                        }
                        .padding(16)
                        .background(
                            LinearGradient(
                                colors: [ThemeBB.premiumGold.opacity(0.15), ThemeBB.electricBlue.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(ThemeBB.premiumGold.opacity(0.3), lineWidth: 1)
                        )
                        
                        // Ultra-Premium Widgets Grid
                        HStack(spacing: 16) {
                            // Hydration Widget
                            ZStack {
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(.ultraThinMaterial)
                                    .shadow(color: ThemeBB.electricBlue.opacity(0.2), radius: 10, y: 5)
                                
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(
                                        LinearGradient(colors: [ThemeBB.electricBlue.opacity(0.25), Color.black.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    )
                                    .overlay(RoundedRectangle(cornerRadius: 24).stroke(ThemeBB.electricBlue.opacity(0.5), lineWidth: 1))
                                
                                VStack(spacing: 0) {
                                    HStack(alignment: .top) {
                                        Image(systemName: "drop.fill")
                                            .foregroundColor(.white)
                                            .font(.body)
                                            .padding(8)
                                            .background(Circle().fill(ThemeBB.electricBlue))
                                            .shadow(color: ThemeBB.electricBlue.opacity(0.5), radius: 4)
                                        Spacer()
                                    }
                                    
                                    Spacer()
                                    
                                    ZStack {
                                        Circle().stroke(Color.white.opacity(0.15), lineWidth: 10)
                                        Circle()
                                            .trim(from: 0, to: CGFloat(glasses) / 8.0)
                                            .stroke(
                                                AngularGradient(colors: [ThemeBB.electricBlue, ThemeBB.neonMint], center: .center, startAngle: .degrees(-90), endAngle: .degrees(270)),
                                                style: StrokeStyle(lineWidth: 10, lineCap: .round)
                                            )
                                            .rotationEffect(.degrees(-90))
                                            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: glasses)
                                        
                                        VStack(spacing: 2) {
                                            Text("\(glasses)")
                                                .font(.system(size: 26, weight: .heavy, design: .rounded))
                                                .foregroundColor(.white)
                                            Text("of 8")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(.white.opacity(0.5))
                                                .textCase(.uppercase)
                                        }
                                    }
                                    .frame(width: 80, height: 80)
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 24) {
                                        Button {
                                            let impact = UIImpactFeedbackGenerator(style: .light)
                                            impact.impactOccurred()
                                            if glasses > 0 { glasses -= 1; UserDefaults.standard.set(glasses, forKey: hydrationKey) }
                                        } label: {
                                            Image(systemName: "minus")
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(.white.opacity(0.7))
                                                .frame(width: 32, height: 32)
                                                .background(Circle().fill(Color.white.opacity(0.1)))
                                        }
                                        
                                        Button {
                                            let impact = UIImpactFeedbackGenerator(style: .light)
                                            impact.impactOccurred()
                                            if glasses < 8 { glasses += 1; UserDefaults.standard.set(glasses, forKey: hydrationKey) }
                                        } label: {
                                            Image(systemName: "plus")
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(.white)
                                                .frame(width: 32, height: 32)
                                                .background(Circle().fill(ThemeBB.electricBlue))
                                                .shadow(color: ThemeBB.electricBlue.opacity(0.6), radius: 4)
                                        }
                                    }
                                }
                                .padding(16)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .onAppear {
                                glasses = UserDefaults.standard.integer(forKey: hydrationKey)
                            }
                            
                            // Mood Widget
                            ZStack {
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(.ultraThinMaterial)
                                    .shadow(color: ThemeBB.neonMint.opacity(0.2), radius: 10, y: 5)
                                
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(
                                        LinearGradient(colors: [ThemeBB.neonMint.opacity(0.25), Color.black.opacity(0.2)], startPoint: .topTrailing, endPoint: .bottomLeading)
                                    )
                                    .overlay(RoundedRectangle(cornerRadius: 24).stroke(ThemeBB.neonMint.opacity(0.5), lineWidth: 1))
                                
                                VStack(spacing: 0) {
                                    HStack(alignment: .top) {
                                        Spacer()
                                        Image(systemName: "face.smiling.inverse")
                                            .foregroundColor(ThemeBB.primaryIndigo)
                                            .font(.body)
                                            .padding(8)
                                            .background(Circle().fill(ThemeBB.neonMint))
                                            .shadow(color: ThemeBB.neonMint.opacity(0.5), radius: 4)
                                    }
                                    
                                    Spacer()
                                    
                                    if let mood = selectedMood {
                                        VStack(spacing: 12) {
                                            AssetMapBB.moodImage(for: mood)
                                                .frame(width: 70, height: 70)
                                                .shadow(color: ThemeBB.neonMint.opacity(0.4), radius: 10, y: 4)
                                                .transition(.scale.combined(with: .opacity))
                                            
                                            Text(["Rough", "Meh", "Okay", "Good", "Great"][mood])
                                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                                .foregroundColor(ThemeBB.neonMint)
                                        }
                                    } else {
                                        VStack(spacing: 16) {
                                            Text("How are you?")
                                                .font(.system(size: 14, weight: .semibold))
                                                .foregroundColor(.white)
                                            
                                            VStack(spacing: 12) {
                                                HStack(spacing: 12) {
                                                    ForEach(0..<3, id: \.self) { i in
                                                        MoodButton(index: i, logAction: logMood)
                                                    }
                                                }
                                                HStack(spacing: 12) {
                                                    ForEach(3..<5, id: \.self) { i in
                                                        MoodButton(index: i, logAction: logMood)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(16)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .onAppear {
                                selectedMood = viewModel.todaysMoodIndex()
                            }
                        }
                        
                        // Ultra-Premium Insights & Trends Cards
                        HStack(spacing: 16) {
                            // My Focus Insights
                            Button { showInsights = true } label: {
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(
                                            RadialGradient(gradient: Gradient(colors: [ThemeBB.neonMint.opacity(0.4), ThemeBB.primaryIndigo]), center: .topLeading, startRadius: 10, endRadius: 200)
                                        )
                                        .overlay(RoundedRectangle(cornerRadius: 24).stroke(ThemeBB.neonMint.opacity(0.6), lineWidth: 1))
                                        .shadow(color: ThemeBB.neonMint.opacity(0.2), radius: 8, y: 4)
                                        .clipShape(RoundedRectangle(cornerRadius: 24))
                                    
                                    // Decorative Background Icon
                                    VStack {
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            Image(systemName: "brain.head.profile")
                                                .font(.system(size: 80))
                                                .foregroundColor(ThemeBB.neonMint.opacity(0.15))
                                                .offset(x: 20, y: 20)
                                        }
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 24))

                                    VStack(alignment: .leading, spacing: 0) {
                                        HStack {
                                            ZStack {
                                                Circle()
                                                    .fill(Color.white.opacity(0.2))
                                                    .frame(width: 44, height: 44)
                                                Image(systemName: "brain.head.profile")
                                                    .font(.title3)
                                                    .foregroundColor(.white)
                                            }
                                            Spacer()
                                            Image(systemName: "arrow.up.right")
                                                .font(.subheadline.bold())
                                                .foregroundColor(.white.opacity(0.8))
                                        }
                                        Spacer()
                                        VStack(alignment: .leading, spacing: 6) {
                                            HStack(spacing: 4) {
                                                Image(systemName: "flame.fill")
                                                    .foregroundColor(ThemeBB.premiumGold)
                                                Text("\(viewModel.points) XP")
                                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                                                    .foregroundColor(ThemeBB.premiumGold)
                                            }
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(ThemeBB.premiumGold.opacity(0.2))
                                            .clipShape(Capsule())
                                            
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text("Focus Insights")
                                                    .font(.system(size: 17, weight: .bold, design: .rounded))
                                                    .foregroundColor(.white)
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.6)
                                                Text("Productivity Trends")
                                                    .font(.system(size: 11, weight: .medium))
                                                    .foregroundColor(.white.opacity(0.7))
                                                    .lineLimit(1)
                                            }
                                        }
                                    }
                                    .padding(16)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 160)
                            }
                            
                            // Global Goal Trends
                            Button { showInfographic = true } label: {
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(
                                            RadialGradient(gradient: Gradient(colors: [ThemeBB.premiumGold.opacity(0.4), ThemeBB.primaryIndigo]), center: .topTrailing, startRadius: 10, endRadius: 200)
                                        )
                                        .overlay(RoundedRectangle(cornerRadius: 24).stroke(ThemeBB.premiumGold.opacity(0.6), lineWidth: 1))
                                        .shadow(color: ThemeBB.premiumGold.opacity(0.2), radius: 8, y: 4)
                                        .clipShape(RoundedRectangle(cornerRadius: 24))
                                    
                                    // Decorative Background Icon
                                    VStack {
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            Image(systemName: "chart.bar.fill")
                                                .font(.system(size: 80))
                                                .foregroundColor(ThemeBB.premiumGold.opacity(0.15))
                                                .offset(x: 20, y: 20)
                                        }
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 24))

                                    VStack(alignment: .leading, spacing: 0) {
                                        HStack {
                                            Spacer()
                                            ZStack {
                                                Circle()
                                                    .fill(Color.white.opacity(0.2))
                                                    .frame(width: 44, height: 44)
                                                Image(systemName: "globe.americas.fill")
                                                    .font(.title3)
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        Spacer()
                                        VStack(alignment: .leading, spacing: 6) {
                                            HStack(spacing: 4) {
                                                Image(systemName: "person.2.fill")
                                                    .foregroundColor(ThemeBB.neonMint)
                                                Text("Top 5%")
                                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                                                    .foregroundColor(ThemeBB.neonMint)
                                            }
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(ThemeBB.neonMint.opacity(0.2))
                                            .clipShape(Capsule())
                                            
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text("Global Trends")
                                                    .font(.system(size: 17, weight: .bold, design: .rounded))
                                                    .foregroundColor(.white)
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.6)
                                                Text("Community Goals")
                                                    .font(.system(size: 11, weight: .medium))
                                                    .foregroundColor(.white.opacity(0.7))
                                                    .lineLimit(1)
                                            }
                                        }
                                    }
                                    .padding(16)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 160)
                            }
                        }
                        
                        // Goals Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Today's Focus")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Spacer()
                                let activeCount = viewModel.todaysGoals().filter { !$0.isCompleted }.count
                                if activeCount > 0 {
                                    Text("\(activeCount) left")
                                        .font(.caption.bold())
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 10).padding(.vertical, 4)
                                        .background(ThemeBB.neonMint.opacity(0.4))
                                        .clipShape(Capsule())
                                        .overlay(Capsule().stroke(ThemeBB.neonMint, lineWidth: 1))
                                } else {
                                    Image(systemName: "checkmark.seal.fill")
                                        .foregroundColor(ThemeBB.neonMint)
                                        .font(.title3)
                                }
                            }
                            
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
                                    
                                    Text("Every great journey begins with a single step. Tap Boost below to add a new goal and build your streak!")
                                        .font(.subheadline)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white.opacity(0.8))
                                        .padding(.horizontal, 8)
                                }
                                .padding(24)
                                .frame(maxWidth: .infinity)
                                .background {
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(.ultraThinMaterial)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 24)
                                                .stroke(ThemeBB.primaryIndigo.opacity(0.5), lineWidth: 1)
                                        )
                                }
                            } else {
                                VStack(spacing: 12) {
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
                        }
                    }
                    .padding(.horizontal, 20)
                    // Add substantial padding at the bottom so content can scroll past the floating button
                    .padding(.bottom, 160)
                }
            }

            // Dynamic Island Style Floating Button
            VStack {
                Spacer()
                Button {
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                    showingAddGoal = true
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "plus")
                            .font(.title2.bold())
                        Text("Add Boost")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(ThemeBB.primaryIndigo)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 18)
                    .background(ThemeBB.neonMint)
                    .clipShape(Capsule())
                    .shadow(color: ThemeBB.neonMint.opacity(0.4), radius: 20, y: 10)
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
                }
                .padding(.bottom, 90)
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
        
        // Ensure full-screen overlay transitions smoothly
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
            .transition(.opacity.combined(with: .scale(scale: 0.95)))
            .zIndex(100)
        }
    }
    
    private func logMood(_ index: Int) {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            selectedMood = index
            viewModel.logMood(index: index, emoji: ["😞", "😕", "😐", "🙂", "😁"][index], label: ["Rough", "Meh", "Okay", "Good", "Great"][index])
        }
    }
}

fileprivate struct MoodButton: View {
    let index: Int
    let logAction: (Int) -> Void
    
    var body: some View {
        Button {
            logAction(index)
        } label: {
            AssetMapBB.moodImage(for: index)
                .frame(width: 38, height: 38)
                .background(Circle().fill(Color.white.opacity(0.1)))
                .shadow(color: .black.opacity(0.2), radius: 3)
        }
    }
}

#Preview {
    HomeViewBB().environmentObject(ViewModelBB())
}
