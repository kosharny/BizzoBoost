import SwiftUI

struct StatViewBB: View {
    @EnvironmentObject var viewModel: ViewModelBB
    @State private var animatedPoints: Int = 0

    var body: some View {
        ZStack {
            viewModel.currentTheme.backgroundGradient
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Text("Analytics")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)

                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 8) {
                            Text("Total Points")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                            Text("\(animatedPoints)")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(ThemeBB.neonMint)
                                .onAppear {
                                    withAnimation(.easeOut(duration: 1.5)) {
                                        animatedPoints = viewModel.points
                                    }
                                }
                        }
                        .padding(.vertical, 20)

                        VStack(alignment: .leading, spacing: 16) {
                            Text("Categories")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.8))
                            
                            HStack(spacing: 30) {
                                Spacer()
                                
                                PieChartBB(goals: viewModel.goals)
                                    .frame(width: 120, height: 120)
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    LegendRowBB(color: ThemeBB.neonMint, title: "Habits")
                                    LegendRowBB(color: ThemeBB.electricBlue, title: "Study")
                                    LegendRowBB(color: ThemeBB.accentGlow, title: "Sport")
                                }
                                
                                Spacer()
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Weekly Progress")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.8))
                            
                            LineChartBB(goals: viewModel.goals)
                                .frame(height: 200)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Activity Rewards")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.8))
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                ForEach(ActivityLevelBB.allCases, id: \.self) { level in
                                    let isUnlocked = viewModel.points >= level.pointsRequired
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(isUnlocked ? ThemeBB.electricBlue.opacity(0.4) : .white.opacity(0.1))
                                            .aspectRatio(1, contentMode: .fit)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(isUnlocked ? ThemeBB.neonMint : .clear, lineWidth: 2)
                                            )
                                        
                                        VStack(spacing: 8) {
                                            Image(systemName: isUnlocked ? rewardIcon(for: level) : "lock.fill")
                                                .font(.largeTitle)
                                                .foregroundColor(isUnlocked ? ThemeBB.premiumGold : .white.opacity(0.3))
                                            
                                            Text(level.rawValue)
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                                .foregroundColor(isUnlocked ? .white : .white.opacity(0.5))
                                                .multilineTextAlignment(.center)
                                        }
                                        .blur(radius: isUnlocked ? 0 : 1.5)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .padding(.bottom, 100)
                }
            }
        }
    }
    
    // Moved out of body to extension or inside the View correctly
    private func rewardIcon(for level: ActivityLevelBB) -> String {
        switch level {
        case .rookie: return "medal.fill"
        case .sprinter: return "bolt.shield.fill"
        case .rhythmMaster: return "crown.fill"
        }
    }
}

struct PieChartBB: View {
    var goals: [GoalModelBB]
    
    var body: some View {
        let habits = min(CGFloat(goals.filter({ $0.category == "Habits" }).count), 1) * 120
        let study = min(CGFloat(goals.filter({ $0.category == "Study" }).count), 1) * 120
        let sport = min(CGFloat(goals.filter({ $0.category == "Sport" }).count), 1) * 120
        let total = max(habits + study + sport, 1)

        ZStack {
            Circle()
                .strokeBorder(.white.opacity(0.1), lineWidth: 20)
            
            Circle()
                .trim(from: 0, to: habits/total)
                .stroke(ThemeBB.neonMint, lineWidth: 20)
                .rotationEffect(.degrees(-90))
            
            Circle()
                .trim(from: habits/total, to: (habits+study)/total)
                .stroke(ThemeBB.electricBlue, lineWidth: 20)
                .rotationEffect(.degrees(-90))
            
            Circle()
                .trim(from: (habits+study)/total, to: (habits+study+sport)/total)
                .stroke(ThemeBB.accentGlow, lineWidth: 20)
                .rotationEffect(.degrees(-90))
        }
    }
}

struct LegendRowBB: View {
    var color: Color
    var title: String
    var body: some View {
        HStack {
            Circle().fill(color).frame(width: 10, height: 10)
            Text(title).font(.subheadline).foregroundColor(.white)
        }
    }
}

struct LineChartBB: View {
    var goals: [GoalModelBB]
    let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    var body: some View {
        GeometryReader { geometry in
            let points = days.indices.map { index -> CGPoint in
                let h = height(for: index)
                let x = geometry.size.width / CGFloat(days.count - 1) * CGFloat(index)
                let y = geometry.size.height - 30 - h
                return CGPoint(x: x, y: y)
            }
            
            ZStack {
                Path { path in
                    guard points.count > 1 else { return }
                    path.move(to: points[0])
                    for i in 1..<points.count {
                        path.addLine(to: points[i])
                    }
                }
                .stroke(ThemeBB.primaryGradient, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                
                ForEach(points.indices, id: \.self) { index in
                    Circle()
                        .fill(ThemeBB.neonMint)
                        .frame(width: 12, height: 12)
                        .position(points[index])
                        .shadow(color: ThemeBB.neonMint.opacity(0.5), radius: 5)
                }
                
                VStack {
                    Spacer()
                    HStack {
                        ForEach(days.indices, id: \.self) { index in
                            Text(days[index])
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.7))
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.top, 10)
                }
            }
        }
    }
    
    private func height(for index: Int) -> CGFloat {
        let swiftWeekday = index == 6 ? 1 : index + 2
        let dayGoals = goals.filter { Calendar.current.component(.weekday, from: $0.date) == swiftWeekday && $0.isCompleted }
        let points = dayGoals.reduce(0) { $0 + $1.points }
        
        let calculated = CGFloat(points) * 0.5
        // scale points to fit height (max ~150 to leave room for labels)
        return min(max(calculated, 10.0), 150.0)
    }
}

#Preview {
    StatViewBB().environmentObject(ViewModelBB())
}
