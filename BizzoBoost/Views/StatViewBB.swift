import SwiftUI

struct StatViewBB: View {
    @EnvironmentObject var viewModel: ViewModelBB
    @State private var animatedPoints: Int = 0

    var body: some View {
        ZStack {
            VolumetricBackgroundBB(theme: viewModel.currentTheme)
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
                            HStack {
                                Image(systemName: "star.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(ThemeBB.premiumGold)
                                Text("Total Points")
                                    .font(.headline)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            Text("\(animatedPoints)")
                                .font(.system(size: 60, weight: .heavy))
                                .contentTransition(.numericText())
                                .foregroundColor(ThemeBB.neonMint)
                                .shadow(color: ThemeBB.neonMint.opacity(0.4), radius: 10, y: 5)
                                .onAppear {
                                    withAnimation(.easeOut(duration: 1.5)) {
                                        animatedPoints = viewModel.points
                                    }
                                }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 30)
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(.ultraThinMaterial)
                                .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(ThemeBB.premiumGold.opacity(0.3), lineWidth: 1)
                                )
                        )

                        // Weekly Heatmap
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "calendar.badge.checkmark")
                                    .foregroundColor(ThemeBB.neonMint)
                                Text("This Week")
                                    .font(.title3).fontWeight(.bold).foregroundColor(.white)
                            }
                            HStack(spacing: 8) {
                                ForEach(0..<7, id: \.self) { offset in
                                    let date = Calendar.current.date(byAdding: .day, value: offset - 6, to: Date())!
                                    let count = viewModel.goals.filter {
                                        $0.isCompleted && Calendar.current.isDate($0.date, inSameDayAs: date)
                                    }.count
                                    let isToday = Calendar.current.isDateInToday(date)
                                    VStack(spacing: 6) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(count == 0 ? Color.white.opacity(0.07)
                                                : count == 1 ? ThemeBB.neonMint.opacity(0.35)
                                                : count <= 3 ? ThemeBB.neonMint.opacity(0.65)
                                                : ThemeBB.neonMint)
                                            .frame(height: 44)
                                            .overlay(
                                                Text(count > 0 ? "\(count)" : "")
                                                    .font(.caption2).fontWeight(.bold)
                                                    .foregroundColor(.white)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(isToday ? ThemeBB.premiumGold : Color.clear, lineWidth: 1.5)
                                            )
                                        Text(dayLabel(date))
                                            .font(.system(size: 9))
                                            .foregroundColor(isToday ? ThemeBB.premiumGold : .white.opacity(0.4))
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(ThemeBB.neonMint.opacity(0.2), lineWidth: 1))
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "chart.pie.fill")
                                    .foregroundColor(ThemeBB.electricBlue)
                                Text("Categories")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            
                            HStack(spacing: 20) {
                                Spacer()
                                
                                PieChartBB(goals: viewModel.goals)
                                    .frame(width: 140, height: 140)
                                    .shadow(color: .black.opacity(0.3), radius: 10, y: 5)
                                
                                Spacer()
                                
                                VStack(alignment: .leading, spacing: 16) {
                                    LegendRowBB(color: ThemeBB.neonMint, title: "Habits")
                                    LegendRowBB(color: ThemeBB.electricBlue, title: "Study")
                                    LegendRowBB(color: ThemeBB.accentGlow, title: "Sport")
                                }
                                
                                Spacer()
                            }
                            .padding(.vertical, 24)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(.ultraThinMaterial)
                                    .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(ThemeBB.electricBlue.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "chart.xyaxis.line")
                                    .foregroundColor(ThemeBB.neonMint)
                                Text("Weekly Progress")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            
                            LineChartBB(goals: viewModel.goals)
                                .frame(height: 200)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "gift.fill")
                                    .foregroundColor(ThemeBB.premiumGold)
                                Text("Activity Rewards")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            
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
    
    private func dayLabel(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return String(formatter.string(from: date).prefix(1))
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
