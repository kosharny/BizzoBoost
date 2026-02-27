import SwiftUI
import Combine

struct FocusTimerViewBB: View {
    @EnvironmentObject var viewModel: ViewModelBB
    @Environment(\.presentationMode) var presentationMode

    enum FocusPhase: String {
        case work = "Focus"
        case shortBreak = "Short Break"
        case longBreak = "Long Break"
    }

    @State private var phase: FocusPhase = .work
    @State private var secondsLeft: Int = 25 * 60
    @State private var running = false
    @State private var sessionsDone = 0
    @State private var totalMinutesFocused = 0

    let workDuration = 25 * 60
    let shortBreak = 5 * 60
    let longBreak = 15 * 60

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var progress: CGFloat {
        let total: Int
        switch phase {
        case .work: total = workDuration
        case .shortBreak: total = shortBreak
        case .longBreak: total = longBreak
        }
        return CGFloat(total - secondsLeft) / CGFloat(total)
    }

    var phaseColor: Color {
        switch phase {
        case .work: return ThemeBB.neonMint
        case .shortBreak: return ThemeBB.electricBlue
        case .longBreak: return ThemeBB.premiumGold
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [ThemeBB.primaryIndigo, Color(hex: "#1D2E40")],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button { presentationMode.wrappedValue.dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2).foregroundColor(.white)
                    }
                    Spacer()
                    Text("Focus Timer")
                        .font(.title2).fontWeight(.bold).foregroundColor(.white)
                    Spacer()
                    Text("\(sessionsDone) 🍅")
                        .font(.headline).foregroundColor(ThemeBB.premiumGold)
                }
                .padding()

                Spacer()

                // Phase label
                Text(phase.rawValue)
                    .font(.title3).fontWeight(.semibold)
                    .foregroundColor(phaseColor)
                    .padding(.bottom, 16)

                // Countdown ring
                ZStack {
                    Circle()
                        .stroke(phaseColor.opacity(0.12), lineWidth: 14)
                        .frame(width: 240, height: 240)

                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(phaseColor, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                        .frame(width: 240, height: 240)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 1), value: progress)

                    VStack(spacing: 4) {
                        Text(timeString(secondsLeft))
                            .font(.system(size: 56, weight: .thin, design: .rounded))
                            .foregroundColor(.white)
                        Text(running ? "in progress" : "paused")
                            .font(.caption).foregroundColor(.white.opacity(0.4))
                    }
                }

                Spacer()

                // Controls
                HStack(spacing: 32) {
                    Button { resetTimer() } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.title2).foregroundColor(.white.opacity(0.6))
                    }

                    Button {
                        running.toggle()
                    } label: {
                        Image(systemName: running ? "pause.fill" : "play.fill")
                            .font(.system(size: 36))
                            .foregroundColor(ThemeBB.primaryIndigo)
                            .frame(width: 72, height: 72)
                            .background(phaseColor)
                            .clipShape(Circle())
                    }

                    Button { skipPhase() } label: {
                        Image(systemName: "forward.fill")
                            .font(.title2).foregroundColor(.white.opacity(0.6))
                    }
                }

                Spacer()

                // Session mini-stats
                HStack(spacing: 24) {
                    statPill(label: "Sessions", value: "\(sessionsDone)")
                    statPill(label: "Focused", value: "\(totalMinutesFocused) min")
                    statPill(label: "Points", value: "+\(sessionsDone * 10)")
                }
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.hideTabBar = true }
        .onDisappear { viewModel.hideTabBar = false }
        .onReceive(timer) { _ in
            guard running else { return }
            if secondsLeft > 0 {
                secondsLeft -= 1
                if phase == .work { totalMinutesFocused += 1 }
            } else {
                phaseComplete()
            }
        }
    }

    @ViewBuilder
    func statPill(label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value).font(.headline).fontWeight(.bold).foregroundColor(.white)
            Text(label).font(.caption2).foregroundColor(.white.opacity(0.45))
        }
        .padding(.horizontal, 16).padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    func timeString(_ secs: Int) -> String {
        let m = secs / 60, s = secs % 60
        return String(format: "%02d:%02d", m, s)
    }

    func resetTimer() {
        running = false
        secondsLeft = phase == .work ? workDuration : (phase == .shortBreak ? shortBreak : longBreak)
    }

    func skipPhase() {
        running = false
        phaseComplete()
    }

    func phaseComplete() {
        let impact = UINotificationFeedbackGenerator()
        impact.notificationOccurred(.success)
        running = false

        switch phase {
        case .work:
            sessionsDone += 1
            viewModel.points += 10
            phase = sessionsDone % 4 == 0 ? .longBreak : .shortBreak
            secondsLeft = sessionsDone % 4 == 0 ? longBreak : shortBreak
        case .shortBreak, .longBreak:
            phase = .work
            secondsLeft = workDuration
        }
    }
}

#Preview {
    FocusTimerViewBB().environmentObject(ViewModelBB())
}
