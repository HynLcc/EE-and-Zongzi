import SwiftUI

enum Tab: Int, CaseIterable {
    case dashboard, record, history

    var icon: String {
        switch self {
        case .dashboard: "house"
        case .record: "plus.square"
        case .history: "book"
        }
    }

    var label: String {
        switch self {
        case .dashboard: "首页"
        case .record: "记录"
        case .history: "日记"
        }
    }

    var bookmarkColor: Color {
        switch self {
        case .dashboard: JournalTheme.washiYellow
        case .record: JournalTheme.orange
        case .history: JournalTheme.washiLavender
        }
    }
}

struct ContentView: View {
    @State private var selectedTab: Tab = .dashboard

    var body: some View {
        Group {
            switch selectedTab {
            case .dashboard: DashboardView()
            case .record: RecordView(selectedTab: $selectedTab)
            case .history: HistoryView()
            }
        }
        .animation(.easeInOut(duration: 0.2), value: selectedTab)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .safeAreaInset(edge: .bottom) {
            tabBar
        }
    }

    // MARK: - Tab Bar
    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                if tab == .record {
                    // FAB replaces the record tab button
                    fabButton
                        .offset(y: -10)
                } else {
                    tabButton(tab)
                }
            }
        }
        .padding(.horizontal, 4)
        .padding(.top, 8)
        .background(
            JournalTheme.paperWarm
                .shadow(color: JournalTheme.shadowPaper, radius: 8, x: 0, y: -2)
                .ignoresSafeArea(edges: .bottom)
        )
    }

    private func tabButton(_ tab: Tab) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 4) {
                // Bookmark indicator
                RoundedRectangle(cornerRadius: 1)
                    .fill(selectedTab == tab ? tab.bookmarkColor : .clear)
                    .frame(width: 24, height: 3)

                Image(systemName: tab.icon)
                    .font(.system(size: 18))
                    .foregroundStyle(selectedTab == tab ? JournalTheme.inkBrown : JournalTheme.textTertiary)

                Text(tab.label)
                    .font(JournalFonts.tag)
                    .foregroundStyle(selectedTab == tab ? JournalTheme.inkBrown : JournalTheme.textTertiary)
            }
            .frame(maxWidth: .infinity)
        }
        .accessibilityLabel(tab.label)
        .accessibilityAddTraits(selectedTab == tab ? .isSelected : [])
    }

    // MARK: - FAB
    private var fabButton: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = .record
            }
        } label: {
            Image("Flower")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .padding(0)
                .background(JournalTheme.paper)
                .clipShape(RoundedRectangle(cornerRadius: JournalTheme.radius))
                .overlay(
                    RoundedRectangle(cornerRadius: JournalTheme.radius)
                        .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [4, 3]))
                        .foregroundStyle(JournalTheme.orange.opacity(0.5))
                )
                .shadow(color: JournalTheme.shadowSticker, radius: 4, x: 1, y: 2)
        }
        .buttonStyle(FABButtonStyle())
        .accessibilityLabel("记录体重")
    }
}

// MARK: - FAB Button Style
private struct FABButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: WeightRecord.self, inMemory: true)
}
