import Foundation

class StorageManagerBB {
    static let shared = StorageManagerBB()

    private let goalsKey = "goalsKeyBB"
    private let pointsKey = "pointsKeyBB"
    private let onboardingKey = "onboardingCompletedBB"
    private let premiumKey = "premiumEnabledBB"
    private let selectedThemeKey = "selectedThemeKeyBB"

    private var goalsFileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("goalsBB.json")
    }

    private var habitsFileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("habitsBB.json")
    }

    func saveHabits(_ habits: [HabitModelBB]) {
        if let data = try? JSONEncoder().encode(habits) {
            try? data.write(to: habitsFileURL, options: .atomic)
        }
    }

    func loadHabits() -> [HabitModelBB] {
        if let data = try? Data(contentsOf: habitsFileURL),
           let habits = try? JSONDecoder().decode([HabitModelBB].self, from: data) {
            return habits
        }
        return []
    }

    func saveGoals(_ goals: [GoalModelBB]) {
        if let data = try? JSONEncoder().encode(goals) {
            try? data.write(to: goalsFileURL, options: .atomic)
        }
    }

    func loadGoals() -> [GoalModelBB] {
        if let data = try? Data(contentsOf: goalsFileURL),
           let goals = try? JSONDecoder().decode([GoalModelBB].self, from: data) {
            return goals
        }
        // Fallback to UserDefaults if FileManager is empty (for backwards compatibility just in case)
        if let data = UserDefaults.standard.data(forKey: "goalsKeyBB"),
           let goals = try? JSONDecoder().decode([GoalModelBB].self, from: data) {
            return goals
        }
        return []
    }

    func savePoints(_ points: Int) {
        UserDefaults.standard.set(points, forKey: pointsKey)
    }

    func loadPoints() -> Int {
        return UserDefaults.standard.integer(forKey: pointsKey)
    }

    func setOnboardingCompleted() {
        UserDefaults.standard.set(true, forKey: onboardingKey)
    }

    func isOnboardingCompleted() -> Bool {
        return UserDefaults.standard.bool(forKey: onboardingKey)
    }
    
    func setPremium(_ isPremium: Bool) {
        UserDefaults.standard.set(isPremium, forKey: premiumKey)
    }
    
    func isPremium() -> Bool {
        return UserDefaults.standard.bool(forKey: premiumKey)
    }
    
    func setSelectedTheme(id: String) {
        UserDefaults.standard.set(id, forKey: selectedThemeKey)
    }
    
    func getSelectedThemeID() -> String? {
        return UserDefaults.standard.string(forKey: selectedThemeKey)
    }
}
