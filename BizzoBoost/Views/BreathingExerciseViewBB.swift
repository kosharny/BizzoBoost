import SwiftUI
import Combine

struct BreathingExerciseViewBB: View {
    @EnvironmentObject var viewModel: ViewModelBB
    @Environment(\.presentationMode) var presentationMode
    
    enum BreathingPhase: String {
        case idle = "Tap to Begin"
        case inhale = "Inhale"
        case hold = "Hold"
        case exhale = "Exhale"
        case rest = "Rest"
    }
    
    let patterns: [(name: String, inhale: Int, hold: Int, exhale: Int, rest: Int)] = [
        ("Box Breathing", 4, 4, 4, 4),
        ("4-7-8 Relaxation", 4, 7, 8, 0),
        ("Deep Calm", 5, 2, 6, 2)
    ]
    
    @State private var selectedPattern = 0
    @State private var phase: BreathingPhase = .idle
    @State private var circleScale: CGFloat = 0.6
    @State private var countdown = 0
    @State private var cycleCount = 0
    @State private var running = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var pattern: (name: String, inhale: Int, hold: Int, exhale: Int, rest: Int) {
        patterns[selectedPattern]
    }
    
    var body: some View {
        ZStack {
            // Static gradient bg
            LinearGradient(
                colors: [ThemeBB.primaryIndigo, Color(hex: "#1D2E40")],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        running = false
                        phase = .idle
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text("Breathing")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Text("\(cycleCount) cycles")
                        .font(.caption)
                        .foregroundColor(ThemeBB.neonMint)
                }
                .padding()
                
                // Pattern picker
                if !running {
                    Picker("Pattern", selection: $selectedPattern) {
                        ForEach(0..<patterns.count, id: \.self) { i in
                            Text(patterns[i].name).tag(i)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                
                Spacer()
                
                // Breathing ring
                ZStack {
                    // Outer ring
                    Circle()
                        .stroke(ThemeBB.neonMint.opacity(0.15), lineWidth: 2)
                        .frame(width: 260, height: 260)
                    
                    // Progress ring
                    Circle()
                        .stroke(ThemeBB.neonMint.opacity(0.4), lineWidth: 1.5)
                        .frame(width: 240, height: 240)
                    
                    // Animated breath circle
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [ThemeBB.neonMint.opacity(0.5), ThemeBB.electricBlue.opacity(0.2)],
                                center: .center,
                                startRadius: 0,
                                endRadius: 120
                            )
                        )
                        .frame(width: 200, height: 200)
                        .scaleEffect(circleScale)
                        .animation(.easeInOut(duration: Double(phase == .inhale ? pattern.inhale : phase == .exhale ? pattern.exhale : 1)), value: circleScale)
                    
                    // Phase text
                    VStack(spacing: 8) {
                        Text(phase.rawValue)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        if phase != .idle && countdown > 0 {
                            Text("\(countdown)")
                                .font(.system(size: 44, weight: .thin, design: .rounded))
                                .foregroundColor(ThemeBB.neonMint)
                        }
                    }
                }
                .onTapGesture {
                    if !running {
                        startBreathing()
                    }
                }
                
                Spacer()
                
                // Guide
                if !running {
                    VStack(spacing: 8) {
                        patternStep("Inhale", seconds: pattern.inhale, color: ThemeBB.neonMint)
                        if pattern.hold > 0 {
                            patternStep("Hold", seconds: pattern.hold, color: ThemeBB.premiumGold)
                        }
                        patternStep("Exhale", seconds: pattern.exhale, color: ThemeBB.electricBlue)
                        if pattern.rest > 0 {
                            patternStep("Rest", seconds: pattern.rest, color: ThemeBB.accentGlow)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal)
                } else {
                    Button("Stop") {
                        running = false
                        phase = .idle
                        circleScale = 0.6
                    }
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 24)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                }
                
                Spacer(minLength: 40)
            }
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.hideTabBar = true }
        .onDisappear { viewModel.hideTabBar = false }
        .onReceive(timer) { _ in
            guard running else { return }
            if countdown > 1 {
                countdown -= 1
            } else {
                advancePhase()
            }
        }
    }
    
    func startBreathing() {
        running = true
        cycleCount = 0
        triggerPhase(.inhale)
    }
    
    func advancePhase() {
        switch phase {
        case .inhale:
            if pattern.hold > 0 {
                triggerPhase(.hold)
            } else {
                triggerPhase(.exhale)
            }
        case .hold:
            triggerPhase(.exhale)
        case .exhale:
            if pattern.rest > 0 {
                triggerPhase(.rest)
            } else {
                cycleCount += 1
                triggerPhase(.inhale)
            }
        case .rest:
            cycleCount += 1
            triggerPhase(.inhale)
        case .idle:
            break
        }
    }
    
    func triggerPhase(_ newPhase: BreathingPhase) {
        phase = newPhase
        switch newPhase {
        case .inhale:
            countdown = pattern.inhale
            circleScale = 1.0
        case .hold:
            countdown = pattern.hold
        case .exhale:
            countdown = pattern.exhale
            circleScale = 0.6
        case .rest:
            countdown = pattern.rest
        case .idle:
            break
        }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    @ViewBuilder
    func patternStep(_ label: String, seconds: Int, color: Color) -> some View {
        HStack {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(label)
                .font(.subheadline)
                .foregroundColor(.white)
            Spacer()
            Text("\(seconds)s")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
    }
}

#Preview {
    BreathingExerciseViewBB().environmentObject(ViewModelBB())
}
