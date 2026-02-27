import Foundation

struct HabitModelBB: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var icon: String
    var completedDates: [Date] = []

    func isCompletedToday() -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        return completedDates.contains { Calendar.current.isDate($0, inSameDayAs: today) }
    }

    func streakCount() -> Int {
        let today = Calendar.current.startOfDay(for: Date())
        var streak = 0
        var checkDate = today
        while completedDates.contains(where: { Calendar.current.isDate($0, inSameDayAs: checkDate) }) {
            streak += 1
            checkDate = Calendar.current.date(byAdding: .day, value: -1, to: checkDate) ?? checkDate
        }
        return streak
    }

    func last7Days() -> [Bool] {
        return (0..<7).reversed().map { offset in
            let date = Calendar.current.date(byAdding: .day, value: -offset, to: Date())!
            return completedDates.contains { Calendar.current.isDate($0, inSameDayAs: date) }
        }
    }
}
