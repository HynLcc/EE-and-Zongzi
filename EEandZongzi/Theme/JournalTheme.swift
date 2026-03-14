import SwiftUI

enum JournalTheme {
    // MARK: - Core Colors
    static let background = Color(hex: "f2e6c8")
    static let paper = Color(hex: "fffdf7")
    static let paperWarm = Color(hex: "faf5eb")

    // MARK: - Ink Colors
    static let inkBrown = Color(hex: "5c4a3a")
    static let inkLight = Color(hex: "8c7a6a")
    static let textPrimary = Color(hex: "3a3530")
    static let textSecondary = Color(hex: "6b6a65")
    static let textTertiary = Color(hex: "9a9790")

    // MARK: - Accent Colors
    static let orange = Color(hex: "d97757")
    static let orangeLight = Color(hex: "e89b7f")
    static let green = Color(hex: "788c5d")
    static let greenLight = Color(hex: "96a87a")
    static let blue = Color(hex: "6a9bcc")

    // MARK: - Washi Tape Colors
    static let washiPink = Color(hex: "f2cec2")
    static let washiMint = Color(hex: "c8ddd0")
    static let washiYellow = Color(hex: "f0e4b8")
    static let washiLavender = Color(hex: "d8cfe6")

    static let washiColors: [Color] = [washiPink, washiMint, washiYellow, washiLavender]

    // MARK: - Borders & Lines
    static let border = Color(hex: "a08c6e").opacity(0.15)
    static let paperLine = Color(hex: "b4a082").opacity(0.10)

    // MARK: - Shadows
    static let shadowPaper = Color(red: 120/255, green: 100/255, blue: 70/255).opacity(0.08)
    static let shadowSticker = Color(red: 120/255, green: 100/255, blue: 70/255).opacity(0.12)

    // MARK: - Corner Radius
    static let radius: CGFloat = 6

    // MARK: - Rotation helpers
    static func stickerRotation(index: Int) -> Angle {
        let rotations: [Double] = [0.5, -0.8, 1.2, -0.5, 0.8, -1.0, 0.3, -1.2]
        return .degrees(rotations[index % rotations.count])
    }
}

// MARK: - Color Hex Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
