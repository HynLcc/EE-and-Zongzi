import SwiftUI

struct NotebookBackground: View {
    var lineSpacing: CGFloat = 28
    var lineColor: Color = JournalTheme.paperLine

    var body: some View {
        Canvas { context, size in
            // Draw horizontal ruled lines
            var y: CGFloat = lineSpacing
            while y < size.height {
                let path = Path { p in
                    p.move(to: CGPoint(x: 0, y: y))
                    p.addLine(to: CGPoint(x: size.width, y: y))
                }
                context.stroke(path, with: .color(lineColor), lineWidth: 0.5)
                y += lineSpacing
            }
        }
        .background(JournalTheme.background)
    }
}

/// View modifier for notebook background
struct NotebookBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                NotebookBackground()
                    .ignoresSafeArea()
            )
    }
}

extension View {
    func notebookBackground() -> some View {
        modifier(NotebookBackgroundModifier())
    }
}

#Preview {
    NotebookBackground()
}
