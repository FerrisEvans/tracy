import Foundation

/// Pure date math for laying out a month as a 7-column grid.
/// Used by both the app's calendar screen and the widget.
enum MonthMath {
    /// First moment of the month containing `date`.
    static func startOfMonth(containing date: Date, calendar: Calendar) -> Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: date)) ?? date
    }

    static func addMonths(_ delta: Int, to date: Date, calendar: Calendar) -> Date {
        calendar.date(byAdding: .month, value: delta, to: date) ?? date
    }

    /// Cells for a 7-column month grid, top-left to bottom-right.
    /// `nil` cells pad the first and last week so day 1 lands on the correct
    /// weekday column, respecting `calendar.firstWeekday`.
    static func cells(forMonthContaining date: Date, calendar: Calendar) -> [Date?] {
        let start = startOfMonth(containing: date, calendar: calendar)
        guard let dayRange = calendar.range(of: .day, in: .month, for: start) else {
            return []
        }
        let firstWeekday = calendar.component(.weekday, from: start)
        let leadingPadding = (firstWeekday - calendar.firstWeekday + 7) % 7

        var cells: [Date?] = Array(repeating: nil, count: leadingPadding)
        for day in dayRange {
            cells.append(calendar.date(byAdding: .day, value: day - 1, to: start))
        }
        while cells.count % 7 != 0 {
            cells.append(nil)
        }
        return cells
    }

    /// Weekday symbols reordered so the first element matches the grid's
    /// first column (`calendar.firstWeekday`).
    static func orderedWeekdaySymbols(calendar: Calendar) -> [String] {
        let symbols = calendar.veryShortStandaloneWeekdaySymbols
        let first = calendar.firstWeekday - 1
        guard symbols.indices.contains(first) else { return symbols }
        return Array(symbols[first...] + symbols[..<first])
    }
}
