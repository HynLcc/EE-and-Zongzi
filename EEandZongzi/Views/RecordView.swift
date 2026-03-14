import SwiftUI
import SwiftData

struct RecordView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var selectedTab: Tab
    @State private var combinedWeight: String = ""
    @State private var momWeight: String = ""
    @State private var recordDate: Date = .now

    /// 计算出的粽子体重
    private var calculatedBabyWeight: Double? {
        guard let combined = Double(combinedWeight),
              let mom = Double(momWeight),
              combined > mom else { return nil }
        return combined - mom
    }

    /// 两个都填了才能保存
    private var canSave: Bool {
        Double(combinedWeight) != nil && Double(momWeight) != nil
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                Text("记录体重")
                    .font(JournalFonts.title)
                    .foregroundStyle(JournalTheme.inkBrown)
                    .padding(.top, 12)

                // Date picker
                dateField

                // Side by side input
                HStack(alignment: .top, spacing: 16) {
                    // Left: combined weight
                    inputCard(
                        label: "抱着粽子",
                        placeholder: "58.5",
                        text: $combinedWeight,
                        accentColor: JournalTheme.orange,
                        washiColor: JournalTheme.washiPink,
                        rotation: .degrees(0.5)
                    )

                    // Right: mom weight
                    inputCard(
                        label: "EE 自己",
                        placeholder: "52.3",
                        text: $momWeight,
                        accentColor: JournalTheme.green,
                        washiColor: JournalTheme.washiMint,
                        rotation: .degrees(-0.5)
                    )
                }

                // Calculated baby weight preview
                if let baby = calculatedBabyWeight {
                    HStack(spacing: 6) {
                        Text("→ 小粽子")
                            .font(JournalFonts.bodySmall)
                            .foregroundStyle(JournalTheme.inkLight)
                        Text("\(String(format: "%.1f", baby)) kg")
                            .font(JournalFonts.handwrittenBold(24))
                            .foregroundStyle(JournalTheme.orange)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: JournalTheme.radius)
                            .fill(JournalTheme.washiPink.opacity(0.3))
                    )
                    .transition(.scale.combined(with: .opacity))
                }

                // Save button
                saveButton
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .notebookBackground()
    }

    // MARK: - Date Field
    private var dateField: some View {
        HStack {
            Text("日期")
                .font(JournalFonts.label)
                .foregroundStyle(JournalTheme.inkLight)
            DatePicker("", selection: $recordDate, displayedComponents: .date)
                .datePickerStyle(.compact)
                .labelsHidden()
                .tint(JournalTheme.orange)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Input Card
    private func inputCard(
        label: String,
        placeholder: String,
        text: Binding<String>,
        accentColor: Color,
        washiColor: Color = JournalTheme.washiPink,
        rotation: Angle = .degrees(0)
    ) -> some View {
        VStack(spacing: 8) {
            Text(label)
                .font(JournalFonts.label)
                .foregroundStyle(JournalTheme.inkLight)

            HStack(alignment: .firstTextBaseline, spacing: 2) {
                TextField(placeholder, text: text)
                    .font(JournalFonts.number)
                    .foregroundStyle(accentColor)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)

                Text("kg")
                    .font(JournalFonts.label)
                    .foregroundStyle(JournalTheme.inkLight)
            }
            .padding(.vertical, 4)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(accentColor.opacity(0.3))
                    .frame(height: 1)
                    .dash()
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: JournalTheme.radius)
                .fill(JournalTheme.paper)
        )
        .overlay(alignment: .topLeading) {
            WashiTape(color: washiColor, width: 40, height: 10, rotation: .degrees(-4))
                .offset(x: 8, y: -5)
        }
        .shadow(color: JournalTheme.shadowPaper, radius: 2, x: 1, y: 1)
        .rotationEffect(rotation)
    }

    // MARK: - Save Button
    private var saveButton: some View {
        Button {
            saveRecord()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "square.and.pencil")
                Text("记录")
                    .font(JournalFonts.subtitle)
            }
            .foregroundStyle(JournalTheme.paper)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(JournalTheme.orange)
            .clipShape(RoundedRectangle(cornerRadius: JournalTheme.radius))
            .overlay(
                RoundedRectangle(cornerRadius: JournalTheme.radius)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [4, 3]))
                    .foregroundStyle(JournalTheme.paper.opacity(0.4))
            )
        }
        .disabled(!canSave)
        .opacity(canSave ? 1 : 0.5)
        .padding(.top, 8)
    }

    // MARK: - Actions
    private func saveRecord() {
        guard let mom = Double(momWeight) else { return }
        let baby = calculatedBabyWeight
        let record = WeightRecord(
            date: recordDate,
            momWeight: mom,
            babyWeight: baby
        )
        modelContext.insert(record)

        // Reset fields
        combinedWeight = ""
        momWeight = ""

        // Jump to dashboard
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            selectedTab = .dashboard
        }
    }
}

// MARK: - Dash modifier
private struct DashModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.mask(
            Rectangle()
                .overlay(
                    GeometryReader { geo in
                        Path { path in
                            var x: CGFloat = 0
                            while x < geo.size.width {
                                path.addRect(CGRect(x: x, y: 0, width: 4, height: geo.size.height))
                                x += 7
                            }
                        }
                    }
                )
        )
    }
}

extension View {
    func dash() -> some View {
        modifier(DashModifier())
    }
}

#Preview {
    RecordView(selectedTab: .constant(.record))
        .modelContainer(for: WeightRecord.self, inMemory: true)
}
