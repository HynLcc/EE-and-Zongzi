import SwiftUI
import Charts
import SwiftData

struct MomChartView: View {
    @Query(sort: \WeightRecord.date) private var records: [WeightRecord]

    private var latestWeight: Double? { records.last?.momWeight }
    private var weightChange: Double? {
        guard records.count >= 2 else { return nil }
        return records.last!.momWeight - records[records.count - 2].momWeight
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header with inline SVG-style icon
                HStack(spacing: 8) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.title2)
                        .foregroundStyle(JournalTheme.green)
                    Text("EE的体重趋势")
                        .font(JournalFonts.title)
                        .foregroundStyle(JournalTheme.inkBrown)
                }

                Text("记录每一天的变化")
                    .font(JournalFonts.bodySmall)
                    .foregroundStyle(JournalTheme.inkLight)

                // Chart
                chartSection

                // Stats
                statsSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 20)
        }
        .notebookBackground()
    }

    // MARK: - Chart
    private var chartSection: some View {
        JournalCard(washiColor: JournalTheme.washiMint, rotation: .degrees(-0.3)) {
            if records.isEmpty {
                Text("还没有记录哦，去记录第一条吧")
                    .font(JournalFonts.bodyText)
                    .foregroundStyle(JournalTheme.inkLight)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
            } else {
                Chart {
                    ForEach(records) { record in
                        LineMark(
                            x: .value("日期", record.date),
                            y: .value("体重", record.momWeight)
                        )
                        .foregroundStyle(JournalTheme.green)
                        .lineStyle(StrokeStyle(lineWidth: 2))
                    }

                    ForEach(records) { record in
                        PointMark(
                            x: .value("日期", record.date),
                            y: .value("体重", record.momWeight)
                        )
                        .foregroundStyle(JournalTheme.green)
                        .symbolSize(30)
                    }
                }
                .chartXAxis {
                    AxisMarks { value in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [2, 2]))
                            .foregroundStyle(JournalTheme.paperLine)
                        AxisValueLabel {
                            if let date = value.as(Date.self) {
                                Text(date, format: .dateTime.month(.twoDigits).day())
                                    .font(JournalFonts.tag)
                                    .foregroundStyle(JournalTheme.inkLight)
                            }
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [2, 2]))
                            .foregroundStyle(JournalTheme.paperLine)
                        AxisValueLabel {
                            if let kg = value.as(Double.self) {
                                Text(String(format: "%.0f", kg))
                                    .font(JournalFonts.tag)
                                    .foregroundStyle(JournalTheme.inkLight)
                            }
                        }
                    }
                }
                .frame(height: 220)
            }
        }
    }

    // MARK: - Stats
    private var statsSection: some View {
        HStack(spacing: 12) {
            StatCard(
                title: "当前体重",
                value: latestWeight.map { String(format: "%.1f", $0) } ?? "--",
                unit: "kg",
                accentColor: JournalTheme.green,
                washiColor: JournalTheme.washiMint,
                rotation: .degrees(-0.8)
            )

            StatCard(
                title: "上次变化",
                value: weightChange.map { String(format: "%+.1f", $0) } ?? "--",
                unit: "kg",
                subtitle: weightChange.map { $0 > 0 ? "增加" : $0 < 0 ? "减少" : "持平" },
                accentColor: weightChange.map { $0 <= 0 ? JournalTheme.green : JournalTheme.orange } ?? JournalTheme.inkLight,
                washiColor: JournalTheme.washiYellow,
                rotation: .degrees(0.5)
            )
        }
    }
}

#Preview {
    MomChartView()
        .modelContainer(for: WeightRecord.self, inMemory: true)
}
