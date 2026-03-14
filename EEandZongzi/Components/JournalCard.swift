import SwiftUI

struct JournalCard<Content: View>: View {
    var washiColor: Color = JournalTheme.washiPink
    var rotation: Angle = .degrees(0)
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: JournalTheme.radius)
                .fill(JournalTheme.paper)
        )
        .shadow(color: JournalTheme.shadowPaper, radius: 3, x: 1, y: 2)
        .overlay(alignment: .top) {
            WashiTape(color: washiColor, width: 50, height: 12, rotation: .degrees(-2))
                .offset(y: -6)
        }
        .rotationEffect(rotation)
    }
}

#Preview {
    JournalCard(washiColor: JournalTheme.washiMint, rotation: .degrees(0.5)) {
        Text("小粽子的体重")
            .font(JournalFonts.subtitle)
            .foregroundStyle(JournalTheme.inkBrown)
        Text("6.2 kg")
            .font(JournalFonts.numberLarge)
            .foregroundStyle(JournalTheme.orange)
    }
    .padding()
    .background(JournalTheme.background)
}
