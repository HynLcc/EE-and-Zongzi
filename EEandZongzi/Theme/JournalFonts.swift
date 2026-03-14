import SwiftUI

enum JournalFonts {
    // MARK: - Handwritten (Caveat) — for numbers, labels, tags
    static func handwritten(_ size: CGFloat) -> Font {
        .custom("Caveat-Regular", size: size)
    }

    static func handwrittenBold(_ size: CGFloat) -> Font {
        .custom("Caveat-Bold", size: size)
    }

    // MARK: - Chinese Header (ZCOOL XiaoWei) — for titles
    static func header(_ size: CGFloat) -> Font {
        .custom("ZCOOLXiaoWei-Regular", size: size)
    }

    // MARK: - Chinese Body (Noto Serif SC) — for body text
    static func body(_ size: CGFloat) -> Font {
        .custom("NotoSerifSC-ExtraLight", size: size)
    }

    // MARK: - Convenience
    static let title = header(22)
    static let subtitle = header(18)
    static let bodyText = body(14)
    static let bodySmall = body(13)
    static let number = handwrittenBold(28)
    static let numberLarge = handwrittenBold(36)
    static let numberSmall = handwritten(20)
    static let label = handwritten(16)
    static let tag = handwritten(14)
}
