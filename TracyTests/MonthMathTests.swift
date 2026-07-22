import Foundation
import Testing
@testable import Tracy

struct MonthMathTests {
    /// Gregorian calendar pinned to UTC with Sunday as the first weekday,
    /// so expectations don't depend on the machine's locale.
    private var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        calendar.firstWeekday = 1
        return calendar
    }

    // July 1, 2026 is a Wednesday.
    private var july2026: Date {
        calendar.date(from: DateComponents(year: 2026, month: 7, day: 15))!
    }

    @Test func gridIsAMultipleOfSevenCells() {
        let cells = MonthMath.cells(forMonthContaining: july2026, calendar: calendar)
        #expect(cells.count % 7 == 0)
    }

    @Test func gridContainsEveryDayOfTheMonth() {
        let cells = MonthMath.cells(forMonthContaining: july2026, calendar: calendar)
        let days = cells.compactMap { $0 }.map { calendar.component(.day, from: $0) }
        #expect(days == Array(1...31))
    }

    @Test func leadingPaddingAlignsDayOneToItsWeekday() {
        // Sunday-first grid: Wednesday July 1 needs 3 leading blanks.
        let cells = MonthMath.cells(forMonthContaining: july2026, calendar: calendar)
        #expect(cells.prefix(3).allSatisfy { $0 == nil })
        #expect(cells[3] != nil)
        #expect(calendar.component(.day, from: cells[3]!) == 1)
    }

    @Test func mondayFirstCalendarShiftsPadding() {
        var mondayFirst = calendar
        mondayFirst.firstWeekday = 2
        // Monday-first grid: Wednesday July 1 needs 2 leading blanks.
        let cells = MonthMath.cells(forMonthContaining: july2026, calendar: mondayFirst)
        #expect(cells.prefix(2).allSatisfy { $0 == nil })
        #expect(cells[2] != nil)
    }

    @Test func startOfMonthDropsDayComponent() {
        let start = MonthMath.startOfMonth(containing: july2026, calendar: calendar)
        let components = calendar.dateComponents([.year, .month, .day], from: start)
        #expect(components.year == 2026)
        #expect(components.month == 7)
        #expect(components.day == 1)
    }

    @Test func addMonthsCrossesYearBoundary() {
        let december = calendar.date(from: DateComponents(year: 2026, month: 12, day: 10))!
        let next = MonthMath.addMonths(1, to: december, calendar: calendar)
        let components = calendar.dateComponents([.year, .month], from: next)
        #expect(components.year == 2027)
        #expect(components.month == 1)
    }

    @Test func weekdaySymbolsStartAtFirstWeekday() {
        var mondayFirst = calendar
        mondayFirst.firstWeekday = 2
        let symbols = MonthMath.orderedWeekdaySymbols(calendar: mondayFirst)
        #expect(symbols.count == 7)
        #expect(symbols.first == mondayFirst.veryShortStandaloneWeekdaySymbols[1])
    }
}
