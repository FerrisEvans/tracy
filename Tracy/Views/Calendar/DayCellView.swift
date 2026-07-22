import SwiftUI

struct DayCellView: View {
    let date: Date
    let calendar: Calendar
    let summary: DaySummary?
    let onTap: () -> Void

    private var isToday: Bool {
        calendar.isDateInToday(date)
    }

    private var dayNumber: Int {
        calendar.component(.day, from: date)
    }

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                Text("\(dayNumber)")
                    .font(.callout)
                    .fontWeight(isToday ? .bold : .regular)
                    .frame(width: 28, height: 28)
                    .background(
                        isToday ? Color.accentColor.opacity(0.2) : Color.clear,
                        in: Circle()
                    )
                markerIcons
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var markerIcons: some View {
        HStack(spacing: 2) {
            if summary?.hasDiary == true {
                Image(systemName: "book.closed.fill")
                    .foregroundStyle(.indigo)
            }
            if summary?.hasExpense == true {
                Image(systemName: "creditcard.fill")
                    .foregroundStyle(.green)
            }
        }
        .font(.system(size: 8))
        .frame(height: 10)
    }
}
