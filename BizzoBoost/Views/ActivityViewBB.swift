import SwiftUI

struct ActivityViewBB: View {
    @EnvironmentObject var viewModel: ViewModelBB
    @State private var dailyQuizzes: [QuizLevelBB] = []

    var body: some View {
        NavigationView {
            ZStack {
                viewModel.currentTheme.backgroundGradient
                    .ignoresSafeArea()
    
                VStack(spacing: 0) {
                    HStack {
                        Text("Activity")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                        
                        HStack {
                            Image(systemName: "flame.fill")
                                .foregroundColor(ThemeBB.premiumGold)
                            Text("\(viewModel.streak)")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(ThemeBB.premiumGold.opacity(0.2))
                        .clipShape(Capsule())
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Current Level")
                                    .font(.headline)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                HStack {
                                    Image(systemName: "trophy.fill")
                                        .font(.title)
                                        .foregroundColor(ThemeBB.premiumGold)
                                    
                                    VStack(alignment: .leading) {
                                        Text(viewModel.currentLevel.rawValue)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        Text("\(viewModel.points) pts")
                                            .font(.subheadline)
                                            .foregroundColor(ThemeBB.neonMint)
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Daily Quizzes")
                                    .font(.headline)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                ForEach(dailyQuizzes) { level in
                                    NavigationLink(destination: QuizGameplayViewBB(level: level, onComplete: { _ in })) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 6) {
                                                Text("Level \(level.id)")
                                                    .font(.caption)
                                                    .foregroundColor(ThemeBB.neonMint)
                                                Text(level.title)
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                            }
                                            Spacer()
                                            Image(systemName: "play.circle.fill")
                                                .foregroundColor(ThemeBB.electricBlue)
                                                .font(.title)
                                        }
                                        .padding()
                                        .background(.ultraThinMaterial)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Games")
                                    .font(.headline)
                                    .foregroundColor(.white.opacity(0.8))
                                    
                                NavigationLink(destination: ConcentrationGameViewBB()) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Concentration Test")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                            
                                            Text("Improve focus! Tap the Bizzo Boost targets across 10 difficulty stages.")
                                                .font(.subheadline)
                                                .foregroundColor(.white.opacity(0.7))
                                                .multilineTextAlignment(.leading)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "scope")
                                            .font(.system(size: 40))
                                            .foregroundColor(ThemeBB.neonMint)
                                    }
                                    .padding()
                                    .background(.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(ThemeBB.neonMint.opacity(0.5), lineWidth: 1))
                                }
                            }
                        }
                        .padding()
                        .padding(.bottom, 100)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                if dailyQuizzes.isEmpty {
                    dailyQuizzes = Array(QuizLevelBB.allLevels.shuffled().prefix(3))
                }
            }
        }
    }
}

#Preview {
    ActivityViewBB().environmentObject(ViewModelBB())
}
