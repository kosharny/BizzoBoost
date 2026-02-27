import Foundation
import SwiftUI

struct ThemeModelBB: Identifiable, Codable, Equatable {
    var id: String
    var title: String
    var isPremium: Bool
    var isUnlocked: Bool
    var priceString: String
    var colorHex: String
    
    var backgroundGradient: LinearGradient {
        switch id {
        case "premium_theme_cyber_night":
            return LinearGradient(
                colors: [Color(hex: "#0A0B10"), Color(hex: "#111827"), Color(hex: "#00B4FF").opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case "premium_theme_golden_hour":
            return LinearGradient(
                colors: [Color(hex: "#1A0F00"), Color(hex: "#331E00"), Color(hex: "#FFD700").opacity(0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            return LinearGradient(
                colors: [
                    Color(hex: "#1A1B32"),
                    Color(hex: "#1E3250"),
                    Color(hex: "#1A3A42")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}
