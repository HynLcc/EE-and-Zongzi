import SwiftUI
import SwiftData
import Charts

struct DashboardView: View {
    @Query(sort: \WeightRecord.date, order: .reverse) private var records: [WeightRecord]

    private var latestRecord: WeightRecord? { records.first }

    private var allRecordsByDate: [WeightRecord] {
        records.sorted { $0.date < $1.date }
    }

    private var babyRecords: [(month: Double, weight: Double)] {
        allRecordsByDate.compactMap { record in
            guard let weight = record.babyWeight else { return nil }
            return (month: record.babyAgeMonths, weight: weight)
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Hero — Polaroid illustration
                heroSection

                // Date header
                if let record = latestRecord {
                    Text(record.formattedDate)
                        .font(JournalFonts.label)
                        .foregroundStyle(JournalTheme.inkLight)
                }

                // Summary cards
                summaryCards

                // Baby mini chart
                babyMiniChart

                // Mom mini chart
                momMiniChart
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 20)
        }
        .notebookBackground()
    }

    // MARK: - Hero
    private var heroSection: some View {
        VStack(spacing: 12) {
            PolaroidFrame(washiColor: JournalTheme.washiYellow, rotation: .degrees(-1.5)) {
                Image("EEandZongzi")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 160)
            }

            Text("EE和粽子")
                .font(JournalFonts.title)
                .foregroundStyle(JournalTheme.inkBrown)

            Text("记录妈妈和宝宝的每一天")
                .font(JournalFonts.bodySmall)
                .foregroundStyle(JournalTheme.inkLight)
        }
        .padding(.top, 8)
    }

    // MARK: - Summary Cards
    private var summaryCards: some View {
        HStack(spacing: 12) {
            StatCard(
                title: "小粽子",
                value: latestRecord?.babyWeight.map { String(format: "%.1f", $0) } ?? "--",
                unit: "kg",
                subtitle: latestRecord?.babyWeight != nil ? "最近记录" : "暂无数据",
                accentColor: JournalTheme.orange,
                washiColor: JournalTheme.washiPink,
                rotation: JournalTheme.stickerRotation(index: 0)
            )

            StatCard(
                title: "EE",
                value: latestRecord.map { String(format: "%.1f", $0.momWeight) } ?? "--",
                unit: "kg",
                subtitle: latestRecord != nil ? "最近记录" : "暂无数据",
                accentColor: JournalTheme.green,
                washiColor: JournalTheme.washiMint,
                rotation: JournalTheme.stickerRotation(index: 1)
            )
        }
    }

    // MARK: - Baby Mini Chart
    private var babyMiniChart: some View {
        JournalCard(washiColor: JournalTheme.washiPink, rotation: .degrees(0.3)) {
            Text("小粽子的成长曲线")
                .font(JournalFonts.subtitle)
                .foregroundStyle(JournalTheme.inkBrown)
                .padding(.bottom, 8)

            Chart {
                // P3-P97 band
                ForEach(WHOData.girlsWeightForAge) { point in
                    AreaMark(
                        x: .value("月龄", point.month),
                        yStart: .value("P3", point.p3),
                        yEnd: .value("P97", point.p97)
                    )
                    .foregroundStyle(JournalTheme.orange.opacity(0.06))
                }

                // P15-P85 band
                ForEach(WHOData.girlsWeightForAge) { point in
                    AreaMark(
                        x: .value("月龄", point.month),
                        yStart: .value("P15", point.p15),
                        yEnd: .value("P85", point.p85)
                    )
                    .foregroundStyle(JournalTheme.orange.opacity(0.08))
                }

                // P50 dashed line
                ForEach(WHOData.girlsWeightForAge) { point in
                    LineMark(
                        x: .value("月龄", point.month),
                        y: .value("P50", point.p50)
                    )
                    .foregroundStyle(JournalTheme.orange.opacity(0.4))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 3]))
                }

                // Baby data points + line
                ForEach(Array(babyRecords.enumerated()), id: \.offset) { _, record in
                    LineMark(
                        x: .value("月龄", record.month),
                        y: .value("体重", record.weight)
                    )
                    .foregroundStyle(JournalTheme.orange)
                    .lineStyle(StrokeStyle(lineWidth: 2))
                }

                ForEach(Array(babyRecords.enumerated()), id: \.offset) { _, record in
                    PointMark(
                        x: .value("月龄", record.month),
                        y: .value("体重", record.weight)
                    )
                    .foregroundStyle(JournalTheme.orange)
                    .symbolSize(30)
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: 6)) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [2, 2]))
                        .foregroundStyle(JournalTheme.paperLine)
                    AxisValueLabel {
                        if let month = value.as(Double.self) {
                            Text("\(Int(month))")
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
                            Text("\(Int(kg))")
                                .font(JournalFonts.tag)
                                .foregroundStyle(JournalTheme.inkLight)
                        }
                    }
                }
            }
            .frame(height: 150)
        }
    }

    // MARK: - Mom Mini Chart
    private var momMiniChart: some View {
        JournalCard(washiColor: JournalTheme.washiMint, rotation: .degrees(-0.3)) {
            Text("EE的体重趋势")
                .font(JournalFonts.subtitle)
                .foregroundStyle(JournalTheme.inkBrown)
                .padding(.bottom, 8)

            if allRecordsByDate.isEmpty {
                Text("还没有记录")
                    .font(JournalFonts.bodyText)
                    .foregroundStyle(JournalTheme.inkLight)
                    .frame(height: 150)
                    .frame(maxWidth: .infinity)
            } else {
                Chart {
                    ForEach(allRecordsByDate) { record in
                        LineMark(
                            x: .value("日期", record.date),
                            y: .value("体重", record.momWeight)
                        )
                        .foregroundStyle(JournalTheme.green)
                        .lineStyle(StrokeStyle(lineWidth: 2))
                    }

                    ForEach(allRecordsByDate) { record in
                        PointMark(
                            x: .value("日期", record.date),
                            y: .value("体重", record.momWeight)
                        )
                        .foregroundStyle(JournalTheme.green)
                        .symbolSize(25)
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
                .frame(height: 150)
            }
        }
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: WeightRecord.self, inMemory: true)
}
