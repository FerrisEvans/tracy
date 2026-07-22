import Foundation

/// Canonical "yyyy-MM-dd" key used to group all records by calendar day.
/// Stored as a plain string on every model so queries stay simple and
/// CloudKit-compatible.
struct DayKey: Hashable, Comparable, Sendable, Identifiable {
    let value: String

    var id: String { value }

    init(value: String) {
        self.value = value
    }

    init(date: Date, calendar: Calendar = .current) {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        self.value = String(
            format: "%04d-%02d-%02d",
            components.year ?? 0,
            components.month ?? 0,
            components.day ?? 0
        )
    }

    static func today(calendar: Calendar = .current) -> DayKey {
        DayKey(date: Date(), calendar: calendar)
    }

    /// "yyyy-MM" prefix used to group records by month.
    var monthPrefix: String {
        String(value.prefix(7))
    }

    func date(calendar: Calendar = .current) -> Date? {
        let parts = value.split(separator: "-").compactMap { Int($0) }
        guard parts.count == 3 else { return nil }
        var components = DateComponents()
        components.year = parts[0]
        components.month = parts[1]
        components.day = parts[2]
        return calendar.date(from: components)
    }

    static func < (lhs: DayKey, rhs: DayKey) -> Bool {
        lhs.value < rhs.value
    }
}
