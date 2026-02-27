import SwiftUI
import Combine

@MainActor
class ViewModelBB: ObservableObject {
    @Published var goals: [GoalModelBB] = [] {
        didSet {
            StorageManagerBB.shared.saveGoals(goals)
        }
    }
    
    @Published var habits: [HabitModelBB] = [] {
        didSet {
            StorageManagerBB.shared.saveHabits(habits)
        }
    }
    
    @Published var points: Int = 0 {
        didSet {
            StorageManagerBB.shared.savePoints(points)
            checkLevelUp()
        }
    }

    @Published var isOnboardingCompleted: Bool = StorageManagerBB.shared.isOnboardingCompleted()
    @Published var currentLevel: ActivityLevelBB = .rookie
    @Published var activeTab: TabBB = .home
    @Published var hideTabBar: Bool = false
    @Published var streak: Int = 0
    
    // StoreKit & Premium State
    @Published var premiumEnabled: Bool = false
    @Published var currentTheme: ThemeModelBB
    private var cancellables = Set<AnyCancellable>()
    
    static let defaultTheme = ThemeModelBB(id: "default_theme", title: "Classic Mint", isPremium: false, isUnlocked: true, priceString: "Free", colorHex: "00FFA3")
    static let cyberNightTheme = ThemeModelBB(id: "premium_theme_cyber_night", title: "Cyber Night", isPremium: true, isUnlocked: false, priceString: "$1.99", colorHex: "00B4FF")
    static let goldenHourTheme = ThemeModelBB(id: "premium_theme_golden_hour", title: "Golden Hour", isPremium: true, isUnlocked: false, priceString: "$1.99", colorHex: "FFD700")

    init() {
        goals = StorageManagerBB.shared.loadGoals()
        habits = StorageManagerBB.shared.loadHabits()
        points = StorageManagerBB.shared.loadPoints()
        
        let initialPremium = StorageManagerBB.shared.isPremium()
        premiumEnabled = initialPremium
        let savedThemeID = StorageManagerBB.shared.getSelectedThemeID()
        currentTheme = ViewModelBB.resolveTheme(id: savedThemeID, isPremium: initialPremium)
        
        checkLevelUp()
        calculateStreak()
        setupStoreKitSubscription()
    }
    
    private func setupStoreKitSubscription() {
        Publishers.CombineLatest(StoreManagerBB.shared.$purchasedProductIDs, StoreManagerBB.shared.$entitlementsLoaded)
            .receive(on: RunLoop.main)
            .sink { [weak self] purchasedIDs, entitlementsLoaded in
                guard let self = self else { return }
                
                // Only rewrite the user's premium state if StoreKit has finished loading the receipts
                if entitlementsLoaded {
                    let isPremium = !purchasedIDs.isEmpty
                    self.premiumEnabled = isPremium
                    StorageManagerBB.shared.setPremium(isPremium)

                    let savedThemeID = StorageManagerBB.shared.getSelectedThemeID()
                    let resolvedTheme = ViewModelBB.resolveTheme(
                        id: savedThemeID,
                        isPremium: isPremium
                    )

                    if self.currentTheme.id != resolvedTheme.id {
                        self.currentTheme = resolvedTheme
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    static func resolveTheme(id: String?, isPremium: Bool) -> ThemeModelBB {
        guard let id = id else { return defaultTheme }

        if id == cyberNightTheme.id && isPremium {
            return cyberNightTheme
        } else if id == goldenHourTheme.id && isPremium {
            return goldenHourTheme
        } else if id == defaultTheme.id {
            return defaultTheme
        }

        return defaultTheme
    }

    func selectTheme(_ theme: ThemeModelBB) {
        if theme.isPremium {
            if !StoreManagerBB.shared.hasAccess(to: theme) {
                return
            }
        }
        self.currentTheme = theme
        StorageManagerBB.shared.setSelectedTheme(id: theme.id)
    }

    func completeOnboarding() {
        StorageManagerBB.shared.setOnboardingCompleted()
        isOnboardingCompleted = true
    }

    @discardableResult
    func addGoal(title: String, category: String, note: String?, photoData: Data?) -> UUID {
        let newGoal = GoalModelBB(title: title, category: category, date: Date(), isCompleted: false, points: 50, note: note, photoData: photoData)
        goals.append(newGoal)
        return newGoal.id
    }
    
    func addHabit(title: String, icon: String) {
        let habit = HabitModelBB(title: title, icon: icon)
        habits.append(habit)
    }
    
    func checkOffHabit(id: UUID) {
        guard let index = habits.firstIndex(where: { $0.id == id }) else { return }
        let today = Date()
        let alreadyDone = habits[index].isCompletedToday()
        if !alreadyDone {
            habits[index].completedDates.append(today)
            points += 15
        }
    }
    
    func deleteHabit(id: UUID) {
        habits.removeAll { $0.id == id }
    }

    func toggleGoalCompletion(id: UUID) {
        if let index = goals.firstIndex(where: { $0.id == id }) {
            goals[index].isCompleted.toggle()
            if goals[index].isCompleted {
                points += goals[index].points
            } else {
                points -= goals[index].points
                if points < 0 { points = 0 }
            }
        }
    }

    private func checkLevelUp() {
        if points >= ActivityLevelBB.rhythmMaster.pointsRequired {
            currentLevel = .rhythmMaster
        } else if points >= ActivityLevelBB.sprinter.pointsRequired {
            currentLevel = .sprinter
        } else {
            currentLevel = .rookie
        }
    }

    private func calculateStreak() {
        let completedDates = goals.filter { $0.isCompleted }.map { Calendar.current.startOfDay(for: $0.date) }
        let uniqueDates = Set(completedDates).sorted(by: >)
        var currentStreak = 0
        let today = Calendar.current.startOfDay(for: Date())
        
        var checkDate = today
        if !uniqueDates.contains(today) {
            checkDate = Calendar.current.date(byAdding: .day, value: -1, to: today) ?? today
        }

        for date in uniqueDates {
            if date == checkDate {
                currentStreak += 1
                checkDate = Calendar.current.date(byAdding: .day, value: -1, to: checkDate) ?? checkDate
            } else {
                break
            }
        }
        streak = currentStreak
    }

    func todaysGoals() -> [GoalModelBB] {
        let today = Calendar.current.startOfDay(for: Date())
        return goals.filter {
            Calendar.current.isDate($0.date, inSameDayAs: today)
            && $0.category != "Thoughts"
            && $0.category != "Mood"
        }
    }

    func completedGoals() -> [GoalModelBB] {
        return goals.filter { $0.isCompleted }.sorted(by: { $0.date > $1.date })
    }
    
    // MARK: - Daily Mood
    private var todayDateKey: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return "mood_" + formatter.string(from: Date())
    }
    
    func todaysMoodIndex() -> Int? {
        let stored = UserDefaults.standard.integer(forKey: todayDateKey)
        // 0 means never set (UserDefaults returns 0 for missing Int keys), we offset by 1
        let raw = UserDefaults.standard.object(forKey: todayDateKey)
        return raw == nil ? nil : stored - 1
    }
    
    func logMood(index: Int, emoji: String, label: String) {
        // Persist for the day (store index + 1 so 0 can serve as sentinel)
        UserDefaults.standard.set(index + 1, forKey: todayDateKey)
        // Avoid duplicate journal entries for the same day
        let today = Calendar.current.startOfDay(for: Date())
        let alreadyLogged = goals.contains {
            $0.category == "Mood" && Calendar.current.isDate($0.date, inSameDayAs: today)
        }
        if !alreadyLogged {
            let entry = GoalModelBB(
                title: "\(emoji) \(label)",
                category: "Mood",
                date: Date(),
                isCompleted: true,
                points: 5
            )
            goals.append(entry)
            points += 5
        }
    }
}

enum TabBB: String, CaseIterable {
    case home = "house.fill"
    case journal = "book.fill"
    case activity = "flame.fill"
    case stat = "chart.bar.fill"
    case settings = "gearshape.fill"
}
