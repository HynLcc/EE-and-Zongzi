import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    var subtitle: String? = nil
    var accentColor: Color = JournalTheme.orange
    var washiColor: Color = JournalTheme.washiPink
    var rotation: Angle = .degrees(0)

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(JournalFonts.bodySmall)
                .foregroundStyle(JournalTheme.inkLight)

            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(JournalFonts.numberLarge)
                    .foregroundStyle(accentColor)
                    .fixedSize(horizontal: true, vertical: false)
                    .padding(.trailing, 10)
                Text(unit)
                    .font(JournalFonts.label)
                    .foregroundStyle(JournalTheme.inkLight)
            }
            .padding(.trailing, 8)

            if let subtitle {
                Text(subtitle)
                    .font(JournalFonts.tag)
                    .foregroundStyle(JournalTheme.textTertiary)
            }
        }
        .padding(14)
        .padding(.trailing, 4)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: JournalTheme.radius)
                .fill(JournalTheme.paper)
        )
        .shadow(color: JournalTheme.shadowPaper, radius: 2, x: 1, y: 1)
        .overlay(alignment: .topLeading) {
            WashiTape(color: washiColor, width: 40, height: 10, rotation: .degrees(-4))
                .offset(x: 8, y: -5)
        }
        .rotationEffect(rotation)
    }
}

#Preview {
    HStack(spacing: 12) {
        StatCard(
            title: "小粽子",
            value: "6.2",
            unit: "kg",
            subtitle: "P50 百分位",
            rotation: .degrees(0.5)
        )
        StatCard(
            title: "EE",
            value: "52.3",
            unit: "kg",
            accentColor: JournalTheme.green,
            washiColor: JournalTheme.washiMint,
            rotation: .degrees(-0.8)
        )
    }
    .padding()
    .background(JournalTheme.background)
}
