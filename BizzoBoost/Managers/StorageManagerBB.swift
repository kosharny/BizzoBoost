import Foundation

class StorageManagerBB {
    static let shared = StorageManagerBB()

    private let goalsKey = "goalsKeyBB"
    private let pointsKey = "pointsKeyBB"
    private let onboardingKey = "onboardingCompletedBB"
    private let premiumKey = "premiumEnabledBB"
    private let selectedThemeKey = "selectedThemeKeyBB"

    func saveGoals(_ goals: [GoalModelBB]) {
        if let data = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(data, forKey: goalsKey)
        }
    }

    func loadGoals() -> [GoalModelBB] {
        if let data = UserDefaults.standard.data(forKey: goalsKey),
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
