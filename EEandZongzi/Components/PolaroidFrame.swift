import SwiftUI

struct PolaroidFrame<Content: View>: View {
    var washiColor: Color = JournalTheme.washiYellow
    var rotation: Angle = .degrees(-1.5)
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            content()
                .padding(8)
                .padding(.bottom, 20) // Extra bottom for polaroid look
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 2))
        .shadow(color: JournalTheme.shadowSticker, radius: 4, x: 1, y: 2)
        .overlay(alignment: .top) {
            WashiTape(color: washiColor, width: 55, height: 13, rotation: .degrees(3))
                .offset(y: -7)
        }
        .rotationEffect(rotation)
    }
}

#Preview {
    PolaroidFrame {
        Image("EEandZongzi")
            .resizable()
            .scaledToFit()
            .frame(width: 160)
    }
    .padding(40)
    .background(JournalTheme.background)
}
