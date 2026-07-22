import Foundation
import Testing
@testable import Tracy

struct DayKeyTests {
    private var utcCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }

    private func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        utcCalendar.date(from: DateComponents(year: year, month: month, day: day))!
    }

    @Test func formatsDateAsPaddedKey() {
        let key = DayKey(date: date(2026, 7, 5), calendar: utcCalendar)
        #expect(key.value == "2026-07-05")
    }

    @Test func roundTripsBackToSameDay() {
        let original = date(2026, 12, 31)
        let key = DayKey(date: original, calendar: utcCalendar)
        #expect(key.date(calendar: utcCalendar) == original)
    }

    @Test func invalidKeyReturnsNilDate() {
        #expect(DayKey(value: "not-a-date").date(calendar: utcCalendar) == nil)
    }

    @Test func monthPrefixIsYearAndMonth() {
        #expect(DayKey(value: "2026-07-05").monthPrefix == "2026-07")
    }

    @Test func comparesChronologically() {
        #expect(DayKey(value: "2026-01-31") < DayKey(value: "2026-02-01"))
        #expect(DayKey(value: "2025-12-31") < DayKey(value: "2026-01-01"))
    }
}
