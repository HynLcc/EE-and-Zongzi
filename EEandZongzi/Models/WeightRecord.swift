import Foundation
import SwiftData

@Model
final class WeightRecord {
    var date: Date
    var momWeight: Double
    var babyWeight: Double?
    var note: String?

    init(date: Date = .now, momWeight: Double, babyWeight: Double? = nil, note: String? = nil) {
        self.date = date
        self.momWeight = momWeight
        self.babyWeight = babyWeight
        self.note = note
    }

    /// Baby's age in months based on birthday
    static let babyBirthday: Date = {
        var components = DateComponents()
        components.year = 2025
        components.month = 2
        components.day = 14
        return Calendar.current.date(from: components) ?? .now
    }()

    var babyAgeMonths: Double {
        let days = Calendar.current.dateComponents([.day], from: Self.babyBirthday, to: date).day ?? 0
        return Double(days) / 30.44
    }

    private static let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "M月d日 EEEE"
        return formatter
    }()

    private static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "M/d"
        return formatter
    }()

    var formattedDate: String {
        Self.fullDateFormatter.string(from: date)
    }

    var shortDate: String {
        Self.shortDateFormatter.string(from: date)
    }
}
