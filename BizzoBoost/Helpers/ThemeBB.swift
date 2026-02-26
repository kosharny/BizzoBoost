import SwiftUI

enum ThemeBB {
    static let primaryIndigo = Color(hex: "#1E1F3A")
    static let electricBlue = Color(hex: "#2D5BFF")
    static let neonMint = Color(hex: "#00F5D4")
    static let accentGlow = Color(hex: "#7C4DFF")
    static let premiumGold = Color(hex: "#F5B700")

    static let primaryGradient = LinearGradient(
        colors: [primaryIndigo, electricBlue, neonMint],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let backgroundBase = LinearGradient(
        colors: [primaryIndigo, electricBlue, neonMint],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
