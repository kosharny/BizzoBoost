import SwiftUI
import Combine

struct ReflexGameViewBB: View {
    @EnvironmentObject var viewModel: ViewModelBB
    @Environment(\.presentationMode) var presentationMode
    
    @State private var score = 0
    @State private var timeRemaining = 30
    @State private var gameActive = false
    @State private var targetPosition = CGPoint(x: 200, y: 300)
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            VolumetricBackgroundBB(theme: viewModel.currentTheme)
                .ignoresSafeArea()
            GameParticleBackgroundBB(theme: viewModel.currentTheme)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .frame(width: 80, alignment: .leading)
                    
                    Spacer()
                    
                    Text("Reflex Tap")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("Score: \(score)")
                        .font(.headline)
                        .foregroundColor(ThemeBB.premiumGold)
                        .frame(width: 80, alignment: .trailing)
                }
                .padding()
                
                Text(timeRemaining > 0 ? "Time: \(timeRemaining)s" : "Game Over!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(timeRemaining <= 5 ? ThemeBB.accentGlow : .white)
                    .padding(.top, 20)
                
                if !gameActive && timeRemaining == 30 {
                    Button("Start Game") {
                        startGame()
                    }
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(ThemeBB.neonMint)
                    .clipShape(Capsule())
                    .padding(.top, 100)
                } else if timeRemaining == 0 {
                    VStack(spacing: 20) {
                        Text("You scored \(score)!")
                            .font(.largeTitle)
                            .foregroundColor(ThemeBB.premiumGold)
                        
                        Text("+\(score) pts added!")
                            .font(.headline)
                            .foregroundColor(ThemeBB.neonMint)
                        
                        Button("Play Again") {
                            startGame()
                        }
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(ThemeBB.primaryIndigo)
                        .clipShape(Capsule())
                    }
                    .padding(.top, 100)
                }
                
                Spacer()
            }
            
            if gameActive && timeRemaining > 0 {
                GeometryReader { geo in
                    Circle()
                        .fill(ThemeBB.accentGlow)
                        .frame(width: 60, height: 60)
                        .shadow(color: ThemeBB.accentGlow, radius: 10, x: 0, y: 0)
                        .overlay(
                            Circle()
                                .stroke(.white, lineWidth: 2)
                        )
                        .position(targetPosition)
                        .onTapGesture {
                            tappedTarget(in: geo.size)
                        }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.hideTabBar = true
        }
        .onDisappear {
            viewModel.hideTabBar = false
        }
        .onReceive(timer) { _ in
            if gameActive && timeRemaining > 0 {
                timeRemaining -= 1
                if timeRemaining == 0 {
                    endGame()
                }
            }
        }
    }
    
    func startGame() {
        score = 0
        timeRemaining = 30
        gameActive = true
        moveTarget(in: UIScreen.main.bounds.size)
    }
    
    func tappedTarget(in size: CGSize) {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        score += 1
        moveTarget(in: size)
    }
    
    func moveTarget(in size: CGSize) {
        let padding: CGFloat = 40
        let minX = padding
        let maxX = size.width - padding
        let minY = padding + 150
        let maxY = size.height - padding - 50
        
        let safeMaxX = max(minX + 1, maxX)
        let safeMaxY = max(minY + 1, maxY)
        
        let newX = CGFloat.random(in: minX...safeMaxX)
        let newY = CGFloat.random(in: minY...safeMaxY)
        
        withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
            targetPosition = CGPoint(x: newX, y: newY)
        }
    }
    
    func endGame() {
        gameActive = false
        if score > 0 {
            viewModel.points += score
        }
    }
}

#Preview {
    ReflexGameViewBB().environmentObject(ViewModelBB())
}
