import Foundation

struct GoalModelBB: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var category: String
    var date: Date
    var isCompleted: Bool
    var points: Int
    var note: String?
    var photoData: Data?
}
