import Foundation

enum ActivityLevelBB: String, CaseIterable, Codable {
    case rookie = "Rookie"
    case sprinter = "Sprinter"
    case rhythmMaster = "Rhythm Master"

    var pointsRequired: Int {
        switch self {
        case .rookie: return 0
        case .sprinter: return 500
        case .rhythmMaster: return 1500
        }
    }
}
