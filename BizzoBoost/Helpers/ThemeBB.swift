import SwiftUI

enum ThemeBB {
    static let primaryIndigo = Color(hex: "#1A1B32")
    static let electricBlue = Color(hex: "#3D6B8F")
    static let neonMint = Color(hex: "#4DC4A8")
    static let accentGlow = Color(hex: "#6B5C9E")
    static let premiumGold = Color(hex: "#C49A3C")

    static let primaryGradient = LinearGradient(
        colors: [primaryIndigo, electricBlue.opacity(0.7)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let backgroundBase = LinearGradient(
        colors: [primaryIndigo, electricBlue.opacity(0.7)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
