import SwiftUI

struct QuizLevelBB: Identifiable, Hashable {
    let id: Int
    let title: String
    let questions: [QuizQuestionBB]
    
    static func == (lhs: QuizLevelBB, rhs: QuizLevelBB) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static let allLevels: [QuizLevelBB] = [
        QuizLevelBB(id: 1, title: "Time Management Basics", questions: [
            QuizQuestionBB(text: "Which technique uses 25-minute focus intervals?", options: ["Pomodoro", "Eisenhower", "Kanban", "Agile"], correctAnswer: "Pomodoro"),
            QuizQuestionBB(text: "What is the primary goal of time blocking?", options: ["Working longer hours", "Allocating specific time periods to tasks", "Ignoring emails", "Multitasking"], correctAnswer: "Allocating specific time periods to tasks"),
            QuizQuestionBB(text: "According to Parkinson's Law, work expands so as to fill...", options: ["the manager's expectations", "the budget allocated", "the time available for its completion", "the team's capacity"], correctAnswer: "the time available for its completion"),
            QuizQuestionBB(text: "Which of these is a common 'time thief'?", options: ["Drinking water", "Planning tomorrow", "Constant notifications", "Taking breaks"], correctAnswer: "Constant notifications"),
            QuizQuestionBB(text: "What is the two-minute rule?", options: ["Take a 2-minute break every hour", "If a task takes less than 2 minutes, do it now", "Speak for only 2 minutes in meetings", "Plan your day in 2 minutes"], correctAnswer: "If a task takes less than 2 minutes, do it now")
        ]),
        QuizLevelBB(id: 2, title: "Prioritization Strategies", questions: [
            QuizQuestionBB(text: "The Eisenhower Matrix categorizes tasks based on:", options: ["Cost and Time", "Urgency and Importance", "Size and Scope", "Fun and Boring"], correctAnswer: "Urgency and Importance"),
            QuizQuestionBB(text: "In the ABCDE method, 'A' tasks are:", options: ["Archived", "Always ignored", "Absolute necessities", "Appealing but useless"], correctAnswer: "Absolute necessities"),
            QuizQuestionBB(text: "What does the 80/20 rule (Pareto Principle) suggest?", options: ["80% of results come from 20% of efforts", "Work 80% of the day, rest 20%", "80% of people are unproductive", "Spend 80% of time planning"], correctAnswer: "80% of results come from 20% of efforts"),
            QuizQuestionBB(text: "What does 'Eat the Frog' mean?", options: ["Have a healthy breakfast", "Do the hardest, most important task first", "Try new things daily", "Ignore minor tasks"], correctAnswer: "Do the hardest, most important task first"),
            QuizQuestionBB(text: "Which tasks should you 'Delegate' in the Eisenhower Matrix?", options: ["Urgent and Important", "Not Urgent but Important", "Urgent but Not Important", "Neither"], correctAnswer: "Urgent but Not Important")
        ]),
        QuizLevelBB(id: 3, title: "Deep Work & Focus", questions: [
            QuizQuestionBB(text: "Who coined the term 'Deep Work'?", options: ["Tim Ferriss", "Cal Newport", "Simon Sinek", "Elon Musk"], correctAnswer: "Cal Newport"),
            QuizQuestionBB(text: "Deep work requires a state of:", options: ["Distraction-free concentration", "Multitasking", "Continuous collaboration", "Low energy"], correctAnswer: "Distraction-free concentration"),
            QuizQuestionBB(text: "Which environment best supports Deep Work?", options: ["A noisy cafe", "An open-plan office", "A quiet, isolated space", "A moving train"], correctAnswer: "A quiet, isolated space"),
            QuizQuestionBB(text: "What is 'Attention Residue'?", options: ["Tired eyes", "Thoughts lingering on a previous task after switching", "Ignoring someone", "Focusing too hard"], correctAnswer: "Thoughts lingering on a previous task after switching"),
            QuizQuestionBB(text: "Which of activities is considered 'Shallow Work'?", options: ["Writing a book chapter", "Coding a complex algorithm", "Replying to routine emails", "Strategic planning"], correctAnswer: "Replying to routine emails")
        ]),
        QuizLevelBB(id: 4, title: "Overcoming Procrastination", questions: [
            QuizQuestionBB(text: "Procrastination is often a failure of:", options: ["Time management", "Emotional regulation", "Intelligence", "Physical health"], correctAnswer: "Emotional regulation"),
            QuizQuestionBB(text: "What is the '5-Second Rule' by Mel Robbins?", options: ["Eat dropped food within 5 seconds", "Count 5-4-3-2-1 and take physical action", "Rest for 5 seconds between tasks", "Plan your day in 5 seconds"], correctAnswer: "Count 5-4-3-2-1 and take physical action"),
            QuizQuestionBB(text: "How does 'Chunking' tackle procrastination?", options: ["Eating snacks", "Breaking large scary projects into small actionable steps", "Ignoring the task", "Grouping all bad habits"], correctAnswer: "Breaking large scary projects into small actionable steps"),
            QuizQuestionBB(text: "Perfectionism often leads to:", options: ["Flawless work every time", "Paralysis and procrastination", "Faster completion", "Better teamwork"], correctAnswer: "Paralysis and procrastination"),
            QuizQuestionBB(text: "What is 'Structured Procrastination'?", options: ["Scheduling time to do nothing", "Doing other useful tasks to avoid the main one", "Building a desk", "Procrastinating on everything uniformly"], correctAnswer: "Doing other useful tasks to avoid the main one")
        ]),
        QuizLevelBB(id: 5, title: "Habit Formation", questions: [
            QuizQuestionBB(text: "What are the three components of the Habit Loop?", options: ["Start, Middle, End", "Cue, Routine, Reward", "Try, Fail, Succeed", "Plan, Do, Review"], correctAnswer: "Cue, Routine, Reward"),
            QuizQuestionBB(text: "According to 'Atomic Habits', you should focus on:", options: ["Massive immediate changes", "Systems and 1% daily improvements", "Setting huge unrealistic goals", "Pure willpower"], correctAnswer: "Systems and 1% daily improvements"),
            QuizQuestionBB(text: "What is 'Habit Stacking'?", options: ["Doing multiple habits at the exact same time", "Linking a new habit to an existing daily habit", "Storing habits in a list", "Forgetting old habits"], correctAnswer: "Linking a new habit to an existing daily habit"),
            QuizQuestionBB(text: "To break a bad habit, you should make it:", options: ["Invisible, Unattractive, Difficult, Unsatisfying", "Obvious, Attractive, Easy, Satisfying", "Secretive and dark", "Expensive"], correctAnswer: "Invisible, Unattractive, Difficult, Unsatisfying"),
            QuizQuestionBB(text: "Roughly how long does it take to form a new habit (on average)?", options: ["21 days", "2 months (66 days)", "1 week", "1 year"], correctAnswer: "2 months (66 days)")
        ]),
        QuizLevelBB(id: 6, title: "Goal Setting", questions: [
            QuizQuestionBB(text: "What does the 'S' in SMART goals stand for?", options: ["Simple", "Specific", "Standard", "Secret"], correctAnswer: "Specific"),
            QuizQuestionBB(text: "Why are deadlines important in goal setting?", options: ["They cause anxiety", "They create a sense of urgency and prevent Parkinson's Law", "They are legally required", "They make goals look professional"], correctAnswer: "They create a sense of urgency and prevent Parkinson's Law"),
            QuizQuestionBB(text: "An 'Approach Goal' focuses on:", options: ["Avoiding a negative outcome", "Moving toward a positive outcome", "Approaching strangers", "Walking daily"], correctAnswer: "Moving toward a positive outcome"),
            QuizQuestionBB(text: "OKRs stand for:", options: ["Only Key Results", "Objectives and Key Results", "Overhead Kinetic Rates", "Optional KPI Reviews"], correctAnswer: "Objectives and Key Results"),
            QuizQuestionBB(text: "What is the benefit of writing down your goals?", options: ["It wastes ink", "It magically makes them happen", "It increases commitment and clarifies focus", "None"], correctAnswer: "It increases commitment and clarifies focus")
        ]),
        QuizLevelBB(id: 7, title: "Energy Management", questions: [
            QuizQuestionBB(text: "Productivity is a function of time and...?", options: ["Money", "Energy", "Luck", "Coffee"], correctAnswer: "Energy"),
            QuizQuestionBB(text: "What is your 'Ultradian Rhythm'?", options: ["A music genre", "A 90-120 minute cycle of peak energy followed by rest", "Your sleep cycle", "Your breathing rate"], correctAnswer: "A 90-120 minute cycle of peak energy followed by rest"),
            QuizQuestionBB(text: "Which of these is most critical for cognitive energy?", options: ["Caffeine", "Social media", "Quality Sleep", "Bright lights"], correctAnswer: "Quality Sleep"),
            QuizQuestionBB(text: "What is 'Decision Fatigue'?", options: ["Tiring of making choices, leading to worse decisions later", "Working late", "Choosing the wrong lunch", "Being too tired to speak"], correctAnswer: "Tiring of making choices, leading to worse decisions later"),
            QuizQuestionBB(text: "How can you combat Decision Fatigue?", options: ["Make more decisions", "Automate routine choices (e.g., meals, clothes)", "Ask others everything", "Flip a coin"], correctAnswer: "Automate routine choices (e.g., meals, clothes)")
        ]),
        QuizLevelBB(id: 8, title: "Digital Minimalism", questions: [
            QuizQuestionBB(text: "Digital Minimalism advocates for:", options: ["Deleting all apps", "Intentional and highly selective technology use", "Buying smaller phones", "Only using computers offline"], correctAnswer: "Intentional and highly selective technology use"),
            QuizQuestionBB(text: "What is the purpose of 'Batching' emails?", options: ["Checking them constantly", "Processing them all at designated times", "Sending them in bulk", "Auto-deleting them"], correctAnswer: "Processing them all at designated times"),
            QuizQuestionBB(text: "How do infinite scroll feeds affect the brain?", options: ["They improve memory", "They hijack the dopamine reward system", "They build patience", "They have no effect"], correctAnswer: "They hijack the dopamine reward system"),
            QuizQuestionBB(text: "A 'Digital Detox' usually involves:", options: ["Cleaning your keyboard", "A period of abstaining from tech devices to reset", "Buying new devices", "Updating software"], correctAnswer: "A period of abstaining from tech devices to reset"),
            QuizQuestionBB(text: "What is a major benefit of turning off non-essential notifications?", options: ["Saves battery", "Reduces cognitive interruptions", "Makes the phone look clean", "Both A and B"], correctAnswer: "Both A and B")
        ]),
        QuizLevelBB(id: 9, title: "Mindset & Motivation", questions: [
            QuizQuestionBB(text: "A 'Growth Mindset' believes that:", options: ["Abilities are fixed at birth", "Talent alone creates success", "Intelligence and skills can be developed through effort", "Failure is permanent"], correctAnswer: "Intelligence and skills can be developed through effort"),
            QuizQuestionBB(text: "Intrinsic motivation comes from:", options: ["Money", "Internal satisfaction and personal interest", "Praise from others", "Fear of punishment"], correctAnswer: "Internal satisfaction and personal interest"),
            QuizQuestionBB(text: "What is 'Imposter Syndrome'?", options: ["Being a spy", "Doubting your abilities and feeling like a fraud despite success", "Taking credit for others' work", "A medical disease"], correctAnswer: "Doubting your abilities and feeling like a fraud despite success"),
            QuizQuestionBB(text: "The 'Zeigarnik Effect' dictates that:", options: ["People remember uncompleted tasks better than completed ones", "Zebra stripes deter flies", "Coffee improves memory", "Time flies when having fun"], correctAnswer: "People remember uncompleted tasks better than completed ones"),
            QuizQuestionBB(text: "How can the 'Zeigarnik Effect' be utilized?", options: ["By leaving tasks open", "By starting a task to let the brain 'hook' onto finishing it", "By ignoring work", "By working only at night"], correctAnswer: "By starting a task to let the brain 'hook' onto finishing it")
        ]),
        QuizLevelBB(id: 10, title: "Workflow Optimization", questions: [
            QuizQuestionBB(text: "What is 'Context Switching'?", options: ["Changing your background wallpaper", "Jumping between different unrelated tasks or apps", "Moving to a new desk", "Translating languages"], correctAnswer: "Jumping between different unrelated tasks or apps"),
            QuizQuestionBB(text: "Context switching generally results in:", options: ["Higher efficiency", "A significant loss of time and mental energy", "Better creativity", "No noticeable change"], correctAnswer: "A significant loss of time and mental energy"),
            QuizQuestionBB(text: "What does standardizing a process achieve?", options: ["Makes it boring", "Reduces friction and errors for repeated tasks", "Complicates work", "Wastes time"], correctAnswer: "Reduces friction and errors for repeated tasks"),
            QuizQuestionBB(text: "The 'Two-Pizza Rule' (by Jeff Bezos) applies to:", options: ["Lunch breaks", "Keeping meetings/teams small enough to feed with two pizzas", "Working late", "Office parties"], correctAnswer: "Keeping meetings/teams small enough to feed with two pizzas"),
            QuizQuestionBB(text: "What is 'Asynchronous Communication'?", options: ["Talking face-to-face", "Communication that doesn't expect an immediate response (like email)", "Yelling", "Instant messaging requiring instant replies"], correctAnswer: "Communication that doesn't expect an immediate response (like email)")
        ])
    ]
}

struct QuizQuestionBB: Hashable {
    let text: String
    let options: [String]
    let correctAnswer: String
}

struct QuizGameplayViewBB: View {
    @EnvironmentObject var viewModel: ViewModelBB
    @Environment(\.presentationMode) var presentationMode
    let level: QuizLevelBB
    let onComplete: (Bool) -> Void
    
    @State private var currentQuestionIndex = 0
    @State private var score = 0
    @State private var showingResults = false
    @State private var selectedAnswer: String? = nil
    
    var body: some View {
        ZStack {
            viewModel.currentTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with close button
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
                        Image(systemName: score == 5 ? "star.circle.fill" : "xmark.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(score == 5 ? ThemeBB.premiumGold : .red)
                        
                        Text(score == 5 ? "Passed!" : "Failed")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("You scored \(score) out of 5")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                        
                        if score < 5 {
                            Text("You must score a perfect 5/5 to pass.")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                        }
                        
                        Button {
                            onComplete(score == 5)
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Finish")
                                .font(.headline)
                                .foregroundColor(ThemeBB.primaryIndigo)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(ThemeBB.neonMint)
                                .clipShape(Capsule())
                        }
                        .padding(.horizontal, 40)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    VStack(spacing: 24) {
                        HStack {
                            Text("Question \(currentQuestionIndex + 1)/5")
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.6))
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        Text(level.questions[currentQuestionIndex].text)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(minHeight: 120)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal)
                        
                        VStack(spacing: 16) {
                            ForEach(level.questions[currentQuestionIndex].options, id: \.self) { option in
                                Button {
                                    handleAnswer(option)
                                } label: {
                                    Text(option)
                                        .font(.body)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(
                                            selectedAnswer == option
                                            ? (option == level.questions[currentQuestionIndex].correctAnswer ? ThemeBB.neonMint : Color.red)
                                            : Color.white.opacity(0.1)
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(selectedAnswer == option ? .clear : .white.opacity(0.2), lineWidth: 1)
                                        )
                                }
                                .disabled(selectedAnswer != nil)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func handleAnswer(_ answer: String) {
        selectedAnswer = answer
        let isCorrect = answer == level.questions[currentQuestionIndex].correctAnswer
        if isCorrect {
            score += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if currentQuestionIndex < 4 {
                currentQuestionIndex += 1
                selectedAnswer = nil
            } else {
                showingResults = true
            }
        }
    }
}
