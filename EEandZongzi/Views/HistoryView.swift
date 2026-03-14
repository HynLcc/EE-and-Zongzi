import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WeightRecord.date, order: .reverse) private var records: [WeightRecord]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Text("记录日记")
                    .font(JournalFonts.title)
                    .foregroundStyle(JournalTheme.inkBrown)
                    .padding(.bottom, 20)

                if records.isEmpty {
                    emptyState
                } else {
                    // Timeline
                    LazyVStack(spacing: 0) {
                        ForEach(Array(records.enumerated()), id: \.element.id) { index, record in
                            timelineEntry(record, index: index, isLast: index == records.count - 1)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 20)
            .frame(maxWidth: .infinity)
        }
        .notebookBackground()
    }

    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image("EEandZongzi")
                .resizable()
                .scaledToFit()
                .frame(width: 120)
                .opacity(0.6)
            Text("还没有记录哦")
                .font(JournalFonts.subtitle)
                .foregroundStyle(JournalTheme.inkLight)
            Text("点击花花开始记录吧 🌸")
                .font(JournalFonts.bodySmall)
                .foregroundStyle(JournalTheme.textTertiary)
        }
        .padding(.top, 60)
    }

    // MARK: - Timeline Entry
    private func timelineEntry(_ record: WeightRecord, index: Int, isLast: Bool) -> some View {
        HStack(alignment: .top, spacing: 16) {
            // Timeline rail
            VStack(spacing: 0) {
                Circle()
                    .fill(index == 0 ? JournalTheme.orange : JournalTheme.inkLight.opacity(0.4))
                    .frame(width: 8, height: 8)

                if !isLast {
                    Rectangle()
                        .fill(JournalTheme.inkLight.opacity(0.2))
                        .frame(width: 1)
                        .frame(maxHeight: .infinity)
                        .dash()
                }
            }
            .frame(width: 8)

            // Content card
            VStack(alignment: .leading, spacing: 6) {
                // Date
                Text(record.formattedDate)
                    .font(JournalFonts.label)
                    .foregroundStyle(JournalTheme.inkLight)

                // Weights
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Text("EE")
                            .font(JournalFonts.bodySmall)
                            .foregroundStyle(JournalTheme.inkLight)
                        Text("\(String(format: "%.1f", record.momWeight)) kg")
                            .font(JournalFonts.handwrittenBold(18))
                            .foregroundStyle(JournalTheme.green)
                    }

                    if let baby = record.babyWeight {
                        HStack(spacing: 4) {
                            Text("粽子")
                                .font(JournalFonts.bodySmall)
                                .foregroundStyle(JournalTheme.inkLight)
                            Text("\(String(format: "%.1f", baby)) kg")
                                .font(JournalFonts.handwrittenBold(18))
                                .foregroundStyle(JournalTheme.orange)
                        }
                    }
                }

                // Note
                if let note = record.note, !note.isEmpty {
                    Text(note)
                        .font(JournalFonts.bodySmall)
                        .foregroundStyle(JournalTheme.textSecondary)
                        .italic()
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(JournalTheme.paper)
            .clipShape(RoundedRectangle(cornerRadius: JournalTheme.radius))
            .shadow(color: JournalTheme.shadowPaper, radius: 2, x: 1, y: 1)
            .overlay(alignment: .topTrailing) {
                WashiTape(
                    color: JournalTheme.washiColors[index % JournalTheme.washiColors.count],
                    width: 32,
                    height: 8,
                    rotation: .degrees(index.isMultiple(of: 2) ? -6 : 4)
                )
                .offset(x: -8, y: -4)
            }
            .rotationEffect(JournalTheme.stickerRotation(index: index))
            .padding(.bottom, 12)
            .contextMenu {
                Button(role: .destructive) {
                    withAnimation {
                        modelContext.delete(record)
                    }
                } label: {
                    Label("删除记录", systemImage: "trash")
                }
            }
        }
    }
}

#Preview {
    HistoryView()
        .modelContainer(for: WeightRecord.self, inMemory: true)
}
