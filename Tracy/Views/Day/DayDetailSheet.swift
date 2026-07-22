import SwiftData
import SwiftUI

/// Bottom sheet for one day: diary editor plus expense list.
struct DayDetailSheet: View {
    let dayKey: DayKey

    @Environment(\.dismiss) private var dismiss

    @Query private var entries: [DiaryEntry]
    @Query private var expenses: [ExpenseRecord]

    @State private var errorMessage: String?

    init(dayKey: DayKey) {
        self.dayKey = dayKey
        let key = dayKey.value
        _entries = Query(filter: #Predicate<DiaryEntry> { $0.dayKey == key })
        _expenses = Query(
            filter: #Predicate<ExpenseRecord> { $0.dayKey == key },
            sort: \ExpenseRecord.createdAt
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                DiarySection(
                    dayKey: dayKey,
                    entry: entries.first,
                    onError: { errorMessage = $0 }
                )
                ExpenseSection(
                    dayKey: dayKey,
                    expenses: expenses,
                    onError: { errorMessage = $0 }
                )
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .alert(
                "Something went wrong",
                isPresented: Binding(
                    get: { errorMessage != nil },
                    set: { if !$0 { errorMessage = nil } }
                )
            ) {
                Button("OK", role: .cancel) { errorMessage = nil }
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }

    private var title: String {
        dayKey.date().map { $0.formatted(date: .abbreviated, time: .omitted) } ?? dayKey.value
    }
}
