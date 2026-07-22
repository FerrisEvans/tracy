import SwiftData
import SwiftUI
import WidgetKit

struct MonthCalendarEntry: TimelineEntry {
    let date: Date
    let summaries: [String: DaySummary]
}

struct MonthCalendarProvider: TimelineProvider {
    func placeholder(in context: Context) -> MonthCalendarEntry {
        MonthCalendarEntry(date: Date(), summaries: [:])
    }

    func getSnapshot(in context: Context, completion: @escaping (MonthCalendarEntry) -> Void) {
        completion(loadEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MonthCalendarEntry>) -> Void) {
        let entry = loadEntry()
        let calendar = Calendar.current
        let nextMidnight = calendar.startOfDay(
            for: calendar.date(byAdding: .day, value: 1, to: entry.date)
                ?? entry.date.addingTimeInterval(86_400)
        )
        completion(Timeline(entries: [entry], policy: .after(nextMidnight)))
    }

    /// Reads the shared App Group store and reduces the current month to
    /// a per-day summary map.
    private func loadEntry() -> MonthCalendarEntry {
        let now = Date()
        let monthPrefix = DayKey(date: now).monthPrefix
        do {
            let context = ModelContext(ModelContainerFactory.makeShared())
            let diaryKeys = try context.fetch(FetchDescriptor<DiaryEntry>())
                .map(\.dayKey)
                .filter { $0.hasPrefix(monthPrefix) }
            let expenseKeys = try context.fetch(FetchDescriptor<ExpenseRecord>())
                .map(\.dayKey)
                .filter { $0.hasPrefix(monthPrefix) }
            return MonthCalendarEntry(
                date: now,
                summaries: DaySummaryBuilder.build(
                    diaryDayKeys: diaryKeys,
                    expenseDayKeys: expenseKeys
                )
            )
        } catch {
            return MonthCalendarEntry(date: now, summaries: [:])
        }
    }
}

struct MonthCalendarWidgetView: View {
    var entry: MonthCalendarEntry

    private let calendar = AppLocalization.calendar

    var body: some View {
        VStack(spacing: 4) {
            Text(entry.date, format: .dateTime.year().month(.wide))
                .font(.caption.bold())
            monthGrid
        }
        .containerBackground(.background, for: .widget)
        .environment(\.locale, AppLocalization.locale)
    }

    private var monthGrid: some View {
        let cells = MonthMath.cells(forMonthContaining: entry.date, calendar: calendar)
        let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 7)
        return LazyVGrid(columns: columns, spacing: 2) {
            ForEach(Array(cells.enumerated()), id: \.offset) { _, cell in
                if let date = cell {
                    WidgetDayCell(
                        date: date,
                        calendar: calendar,
                        summary: entry.summaries[DayKey(date: date, calendar: calendar).value]
                    )
                } else {
                    Color.clear
                }
            }
        }
    }
}

struct WidgetDayCell: View {
    let date: Date
    let calendar: Calendar
    let summary: DaySummary?

    private var isToday: Bool {
        calendar.isDateInToday(date)
    }

    var body: some View {
        VStack(spacing: 1) {
            Text("\(calendar.component(.day, from: date))")
                .font(.system(size: 9, weight: isToday ? .bold : .regular))
                .foregroundStyle(isToday ? Color.accentColor : Color.primary)
            markers
        }
    }

    private var markers: some View {
        HStack(spacing: 1) {
            if summary?.hasDiary == true {
                Circle().fill(.indigo).frame(width: 3, height: 3)
            }
            if summary?.hasExpense == true {
                Circle().fill(.green).frame(width: 3, height: 3)
            }
        }
        .frame(height: 3)
    }
}

struct MonthCalendarWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "MonthCalendarWidget", provider: MonthCalendarProvider()) { entry in
            MonthCalendarWidgetView(entry: entry)
        }
        .configurationDisplayName("本月概览")
        .description("一览本月记了日记和账的日子。")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}
