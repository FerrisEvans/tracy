import SwiftData
import SwiftUI
import WidgetKit

struct ExpenseSection: View {
    let dayKey: DayKey
    let expenses: [ExpenseRecord]
    let onError: (String) -> Void

    @Environment(\.modelContext) private var context

    @State private var amountText = ""
    @State private var category: ExpenseCategory = .food
    @State private var note = ""

    var body: some View {
        Section("Expenses") {
            ForEach(expenses) { expense in
                ExpenseRowView(expense: expense, currencyCode: currencyCode)
            }
            .onDelete(perform: delete)

            HStack {
                TextField("Amount", text: $amountText)
                    .keyboardType(.decimalPad)
                Picker("Category", selection: $category) {
                    ForEach(ExpenseCategory.allCases) { category in
                        Label(category.displayName, systemImage: category.symbolName)
                            .tag(category)
                    }
                }
                .labelsHidden()
                // Keep the menu from greedily expanding over the Add button's
                // tap area, and give Add its own hit region within the row.
                .fixedSize()
                Button("Add") { add() }
                    .buttonStyle(.borderless)
                    .disabled(parsedAmount == nil)
            }
            TextField("Note (optional)", text: $note)
        }
    }

    private var currencyCode: String {
        Locale.current.currency?.identifier ?? "USD"
    }

    private var parsedAmount: Decimal? {
        guard
            let value = Decimal(string: amountText, locale: .current),
            value > 0
        else { return nil }
        return value
    }

    private func add() {
        guard let amount = parsedAmount else { return }
        context.insert(
            ExpenseRecord(
                dayKey: dayKey.value,
                amount: amount,
                category: category.rawValue,
                note: note.trimmingCharacters(in: .whitespacesAndNewlines)
            )
        )
        persist()
        amountText = ""
        note = ""
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            context.delete(expenses[index])
        }
        persist()
    }

    private func persist() {
        do {
            try context.save()
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            onError("Could not save changes. Please try again.")
        }
    }
}

private struct ExpenseRowView: View {
    let expense: ExpenseRecord
    let currencyCode: String

    private var category: ExpenseCategory? {
        ExpenseCategory(rawValue: expense.category)
    }

    var body: some View {
        HStack {
            Image(systemName: category?.symbolName ?? "square.grid.2x2")
                .foregroundStyle(.secondary)
            VStack(alignment: .leading) {
                Text(expense.note.isEmpty ? (category?.displayName ?? expense.category) : expense.note)
                Text(expense.createdAt.formatted(date: .omitted, time: .shortened))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(expense.amount.formatted(.currency(code: currencyCode)))
                .monospacedDigit()
        }
    }
}
