import SwiftUI
import Charts
import SwiftData

// MARK: - WHO Data (Girls 0–24 months weight-for-age)
struct WHODataPoint: Identifiable {
    let id = UUID()
    let month: Double
    let p3: Double
    let p15: Double
    let p50: Double
    let p85: Double
    let p97: Double
}

enum WHOData {
    // Source: WHO Child Growth Standards, girls weight-for-age percentiles (0-24 months)
    static let girlsWeightForAge: [WHODataPoint] = [
        WHODataPoint(month: 0,  p3: 2.4, p15: 2.8, p50: 3.2, p85: 3.7, p97: 4.2),
        WHODataPoint(month: 1,  p3: 3.2, p15: 3.6, p50: 4.2, p85: 4.8, p97: 5.4),
        WHODataPoint(month: 2,  p3: 4.0, p15: 4.5, p50: 5.1, p85: 5.9, p97: 6.5),
        WHODataPoint(month: 3,  p3: 4.6, p15: 5.1, p50: 5.8, p85: 6.7, p97: 7.4),
        WHODataPoint(month: 4,  p3: 5.1, p15: 5.6, p50: 6.4, p85: 7.3, p97: 8.1),
        WHODataPoint(month: 5,  p3: 5.5, p15: 6.1, p50: 6.9, p85: 7.8, p97: 8.7),
        WHODataPoint(month: 6,  p3: 5.8, p15: 6.4, p50: 7.3, p85: 8.3, p97: 9.2),
        WHODataPoint(month: 7,  p3: 6.1, p15: 6.7, p50: 7.6, p85: 8.7, p97: 9.6),
        WHODataPoint(month: 8,  p3: 6.3, p15: 7.0, p50: 7.9, p85: 9.0, p97: 10.0),
        WHODataPoint(month: 9,  p3: 6.6, p15: 7.3, p50: 8.2, p85: 9.3, p97: 10.4),
        WHODataPoint(month: 10, p3: 6.8, p15: 7.5, p50: 8.5, p85: 9.6, p97: 10.7),
        WHODataPoint(month: 11, p3: 7.0, p15: 7.7, p50: 8.7, p85: 9.9, p97: 11.0),
        WHODataPoint(month: 12, p3: 7.1, p15: 7.9, p50: 8.9, p85: 10.2, p97: 11.3),
        WHODataPoint(month: 13, p3: 7.3, p15: 8.1, p50: 9.2, p85: 10.4, p97: 11.6),
        WHODataPoint(month: 14, p3: 7.5, p15: 8.3, p50: 9.4, p85: 10.7, p97: 11.9),
        WHODataPoint(month: 15, p3: 7.7, p15: 8.5, p50: 9.6, p85: 10.9, p97: 12.2),
        WHODataPoint(month: 16, p3: 7.8, p15: 8.7, p50: 9.8, p85: 11.2, p97: 12.5),
        WHODataPoint(month: 17, p3: 8.0, p15: 8.8, p50: 10.0, p85: 11.4, p97: 12.7),
        WHODataPoint(month: 18, p3: 8.2, p15: 9.0, p50: 10.2, p85: 11.6, p97: 13.0),
        WHODataPoint(month: 19, p3: 8.3, p15: 9.2, p50: 10.4, p85: 11.9, p97: 13.3),
        WHODataPoint(month: 20, p3: 8.5, p15: 9.4, p50: 10.6, p85: 12.1, p97: 13.5),
        WHODataPoint(month: 21, p3: 8.7, p15: 9.6, p50: 10.9, p85: 12.4, p97: 13.8),
        WHODataPoint(month: 22, p3: 8.8, p15: 9.8, p50: 11.1, p85: 12.6, p97: 14.1),
        WHODataPoint(month: 23, p3: 9.0, p15: 9.9, p50: 11.3, p85: 12.8, p97: 14.3),
        WHODataPoint(month: 24, p3: 9.2, p15: 10.1, p50: 11.5, p85: 13.1, p97: 14.6),
    ]
}

// MARK: - Baby Chart View
struct BabyChartView: View {
    @Query(sort: \WeightRecord.date) private var records: [WeightRecord]

    private var babyRecords: [(month: Double, weight: Double)] {
        records.compactMap { record in
            guard let weight = record.babyWeight else { return nil }
            return (month: record.babyAgeMonths, weight: weight)
        }
    }

    private var latestBabyWeight: Double? {
        records.last(where: { $0.babyWeight != nil })?.babyWeight
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                Text("小粽子的成长曲线")
                    .font(JournalFonts.title)
                    .foregroundStyle(JournalTheme.inkBrown)

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
        JournalCard(washiColor: JournalTheme.washiLavender, rotation: .degrees(0.3)) {
            Chart {
                // P3-P97 band (lightest)
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

                // P50 line
                ForEach(WHOData.girlsWeightForAge) { point in
                    LineMark(
                        x: .value("月龄", point.month),
                        y: .value("P50", point.p50)
                    )
                    .foregroundStyle(JournalTheme.orange.opacity(0.4))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 3]))
                }

                // Baby's actual data
                ForEach(Array(babyRecords.enumerated()), id: \.offset) { _, record in
                    PointMark(
                        x: .value("月龄", record.month),
                        y: .value("体重", record.weight)
                    )
                    .foregroundStyle(JournalTheme.orange)
                    .symbolSize(40)
                }

                ForEach(Array(babyRecords.enumerated()), id: \.offset) { _, record in
                    LineMark(
                        x: .value("月龄", record.month),
                        y: .value("体重", record.weight)
                    )
                    .foregroundStyle(JournalTheme.orange)
                    .lineStyle(StrokeStyle(lineWidth: 2))
                }
            }
            .chartXAxisLabel("月龄", alignment: .trailing)
            .chartYAxisLabel("体重 (kg)")
            .chartXAxis {
                AxisMarks(values: .stride(by: 3)) { value in
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
            .frame(height: 240)
        }
    }

    // MARK: - Stats
    private var statsSection: some View {
        HStack(spacing: 12) {
            StatCard(
                title: "当前体重",
                value: latestBabyWeight.map { String(format: "%.1f", $0) } ?? "--",
                unit: "kg",
                accentColor: JournalTheme.orange,
                washiColor: JournalTheme.washiPink,
                rotation: .degrees(0.8)
            )

            StatCard(
                title: "记录次数",
                value: "\(babyRecords.count)",
                unit: "次",
                accentColor: JournalTheme.inkBrown,
                washiColor: JournalTheme.washiYellow,
                rotation: .degrees(-0.5)
            )
        }
    }
}

#Preview {
    BabyChartView()
        .modelContainer(for: WeightRecord.self, inMemory: true)
}
