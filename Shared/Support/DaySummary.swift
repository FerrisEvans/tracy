import Foundation

/// What kinds of records exist on a given day — drives the icons shown
/// in the calendar grid and the widget.
struct DaySummary: Equatable, Sendable {
    var hasDiary = false
    var hasExpense = false
}

enum DaySummaryBuilder {
    /// Collapses raw day-key lists into a per-day summary map.
    static func build(
        diaryDayKeys: some Sequence<String>,
        expenseDayKeys: some Sequence<String>
    ) -> [String: DaySummary] {
        var result: [String: DaySummary] = [:]
        for key in diaryDayKeys {
            result[key, default: DaySummary()].hasDiary = true
        }
        for key in expenseDayKeys {
            result[key, default: DaySummary()].hasExpense = true
        }
        return result
    }
}
