import SwiftUI
import Combine

struct ConcentrationLevelBB {
    let levelNumber: Int
    let targetSize: CGFloat
    let requiredScore: Int
    
    static let allLevels: [ConcentrationLevelBB] = [
        ConcentrationLevelBB(levelNumber: 1, targetSize: 120, requiredScore: 10),
        ConcentrationLevelBB(levelNumber: 2, targetSize: 110, requiredScore: 12),
        ConcentrationLevelBB(levelNumber: 3, targetSize: 100, requiredScore: 15),
        ConcentrationLevelBB(levelNumber: 4, targetSize: 90, requiredScore: 18),
        ConcentrationLevelBB(levelNumber: 5, targetSize: 80, requiredScore: 20),
        ConcentrationLevelBB(levelNumber: 6, targetSize: 75, requiredScore: 23),
        ConcentrationLevelBB(levelNumber: 7, targetSize: 70, requiredScore: 25),
        ConcentrationLevelBB(levelNumber: 8, targetSize: 60, requiredScore: 28),
        ConcentrationLevelBB(levelNumber: 9, targetSize: 50, requiredScore: 30),
        ConcentrationLevelBB(levelNumber: 10, targetSize: 40, requiredScore: 35)
    ]
}

struct ConcentrationGameViewBB: View {
    @EnvironmentObject var viewModel: ViewModelBB
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("passedConcentrationLevel") var passedLevel: Int = 0
    
    @State private var currentLevelIndex: Int = 0
    
    @State private var score = 0
    @State private var timeRemaining = 30
    @State private var isPlaying = false
    @State private var showingResults = false
    
    @State private var targetX: CGFloat = UIScreen.main.bounds.width / 2
    @State private var targetY: CGFloat = UIScreen.main.bounds.height / 2
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        let level = ConcentrationLevelBB.allLevels[currentLevelIndex]
        
        ZStack {
            viewModel.currentTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with Close
                HStack {
                    Spacer()
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
                .padding()
                
                if showingResults {
                    VStack(spacing: 30) {
                        let passed = score >= level.requiredScore
                        Image(systemName: passed ? "star.circle.fill" : "xmark.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(passed ? ThemeBB.premiumGold : .red)
                        
                        Text(passed ? "Level Passed!" : "Level Failed")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("You tapped it \(score) times.")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                        
                        if passed {
                            Button {
                                if currentLevelIndex < 9 {
                                    currentLevelIndex += 1
                                    startGame()
                                } else {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            } label: {
                                Text(currentLevelIndex < 9 ? "Next Level" : "Finish Game")
                                    .font(.headline)
                                    .foregroundColor(ThemeBB.primaryIndigo)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(ThemeBB.neonMint)
                                    .clipShape(Capsule())
                            }
                            .padding(.horizontal, 40)
                        } else {
                            Text("You needed \(level.requiredScore) taps in 30 seconds.")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                                
                            Button {
                                startGame()
                            } label: {
                                Text("Retry")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(ThemeBB.electricBlue)
                                    .clipShape(Capsule())
                            }
                            .padding(.horizontal, 40)
                        }
                    }
                    .frame(maxHeight: .infinity)
                } else if !isPlaying {
                    VStack(spacing: 30) {
                        Text(currentLevelIndex == 9 && passedLevel == 10 ? "Game Completed!" : "Level \(level.levelNumber)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Tap the logo as fast as you can. It will teleport after every tap.")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        
                        Text("Goal: \(level.requiredScore) taps\nTime: 30s")
                            .font(.headline)
                            .foregroundColor(ThemeBB.premiumGold)
                            .multilineTextAlignment(.center)
                        
                        Button {
                            startGame()
                        } label: {
                            Text("Start")
                                .font(.headline)
                                .foregroundColor(ThemeBB.primaryIndigo)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(ThemeBB.neonMint)
                                .clipShape(Capsule())
                        }
                        .padding(.horizontal, 80)
                        .padding(.top, 40)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    VStack {
                        HStack {
                            Text("Time: \(timeRemaining)s")
                                .font(.headline)
                                .foregroundColor(timeRemaining <= 10 ? .red : .white)
                            Spacer()
                            Text("Score: \(score)/\(level.requiredScore)")
                                .font(.headline)
                                .foregroundColor(ThemeBB.neonMint)
                        }
                        .padding()
                        Spacer()
                    }
                    
                    Button {
                        handleTap()
                    } label: {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: level.targetSize, height: level.targetSize)
                            .clipShape(Circle())
                            .shadow(color: ThemeBB.neonMint.opacity(0.5), radius: 10)
                    }
                    .position(x: targetX, y: targetY)
                    .onReceive(timer) { _ in
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                        } else {
                            endGame()
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            let nextIndex = passedLevel
            currentLevelIndex = min(nextIndex, 9) // cap at level 10 (index 9)
        }
    }
    
    private func startGame() {
        isPlaying = true
        showingResults = false
        score = 0
        timeRemaining = 30
        moveTarget()
    }
    
    private func handleTap() {
        score += 1
        moveTarget()
    }
    
    private func moveTarget() {
        let level = ConcentrationLevelBB.allLevels[currentLevelIndex]
        let safeXPadding = level.targetSize / 2 + 20
        let safeYPadding = level.targetSize / 2 + 100 
        
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        targetX = CGFloat.random(in: safeXPadding...(screenWidth - safeXPadding))
        targetY = CGFloat.random(in: safeYPadding...(screenHeight - safeYPadding))
    }
    
    private func endGame() {
        isPlaying = false
        showingResults = true
        let level = ConcentrationLevelBB.allLevels[currentLevelIndex]
        if score >= level.requiredScore {
            if passedLevel < level.levelNumber {
                passedLevel = level.levelNumber
            }
        }
    }
}
