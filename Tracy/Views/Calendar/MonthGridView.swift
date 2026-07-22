import SwiftUI

struct MonthGridView: View {
    let month: Date
    let calendar: Calendar
    let summaries: [String: DaySummary]
    let onSelect: (DayKey) -> Void

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        VStack(spacing: 8) {
            LazyVGrid(columns: columns) {
                // Weekday symbols repeat ("S", "T"), so identify by column
                // index — `id: \.self` would collapse the duplicates.
                ForEach(
                    Array(MonthMath.orderedWeekdaySymbols(calendar: calendar).enumerated()),
                    id: \.offset
                ) { _, symbol in
                    Text(symbol)
                        .font(.caption2.bold())
                        .foregroundStyle(.secondary)
                }
            }
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(
                    Array(MonthMath.cells(forMonthContaining: month, calendar: calendar).enumerated()),
                    id: \.offset
                ) { _, cell in
                    if let date = cell {
                        DayCellView(
                            date: date,
                            calendar: calendar,
                            summary: summaries[DayKey(date: date, calendar: calendar).value],
                            onTap: { onSelect(DayKey(date: date, calendar: calendar)) }
                        )
                    } else {
                        Color.clear
                            .frame(height: 44)
                    }
                }
            }
        }
    }
}
