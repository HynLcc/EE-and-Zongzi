import SwiftUI

struct WashiTape: View {
    var color: Color = JournalTheme.washiPink
    var width: CGFloat = 60
    var height: CGFloat = 14
    var rotation: Angle = .degrees(-3)

    var body: some View {
        RoundedRectangle(cornerRadius: 1)
            .fill(color.opacity(0.7))
            .frame(width: width, height: height)
            .overlay(
                // Subtle texture lines
                HStack(spacing: 3) {
                    ForEach(0..<Int(width / 8), id: \.self) { _ in
                        Rectangle()
                            .fill(Color.white.opacity(0.15))
                            .frame(width: 0.5)
                    }
                }
            )
            .rotationEffect(rotation)
    }
}

#Preview {
    VStack(spacing: 30) {
        WashiTape(color: JournalTheme.washiPink)
        WashiTape(color: JournalTheme.washiMint, rotation: .degrees(2))
        WashiTape(color: JournalTheme.washiYellow, rotation: .degrees(-5))
        WashiTape(color: JournalTheme.washiLavender, rotation: .degrees(1))
    }
    .padding()
    .background(JournalTheme.background)
}
