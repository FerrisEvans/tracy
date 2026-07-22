import SwiftData
import SwiftUI

struct CalendarScreen: View {
    @State private var visibleMonth = MonthMath.startOfMonth(
        containing: Date(),
        calendar: .current
    )
    @State private var selectedDay: DayKey?

    @Query private var diaryEntries: [DiaryEntry]
    @Query private var expenses: [ExpenseRecord]

    private let calendar = Calendar.current

    private var summaries: [String: DaySummary] {
        DaySummaryBuilder.build(
            diaryDayKeys: diaryEntries.map(\.dayKey),
            expenseDayKeys: expenses.map(\.dayKey)
        )
    }

    var body: some View {
        VStack(spacing: 16) {
            monthHeader
            MonthGridView(
                month: visibleMonth,
                calendar: calendar,
                summaries: summaries,
                onSelect: { selectedDay = $0 }
            )
            Spacer()
        }
        .padding(.horizontal)
        .sheet(item: $selectedDay) { day in
            DayDetailSheet(dayKey: day)
        }
    }

    private var monthHeader: some View {
        HStack {
            Button {
                visibleMonth = MonthMath.addMonths(-1, to: visibleMonth, calendar: calendar)
            } label: {
                Image(systemName: "chevron.left")
            }
            .accessibilityLabel("Previous month")

            Spacer()

            Text(visibleMonth.formatted(.dateTime.year().month(.wide)))
                .font(.title3.bold())

            Spacer()

            Button {
                visibleMonth = MonthMath.addMonths(1, to: visibleMonth, calendar: calendar)
            } label: {
                Image(systemName: "chevron.right")
            }
            .accessibilityLabel("Next month")
        }
        .padding(.top)
    }
}

#Preview {
    NavigationStack {
        CalendarScreen()
    }
    .modelContainer(ModelContainerFactory.makeInMemory())
}
