import Foundation
import SwiftData

/// A single expense logged on a given day. Multiple records per day allowed.
@Model
final class ExpenseRecord {
    var dayKey: String = ""
    var amount: Decimal = 0
    /// Raw value of `ExpenseCategory`; stored as a string so adding new
    /// categories never requires a schema migration.
    var category: String = ""
    var note: String = ""
    var createdAt: Date = Date()

    init(
        dayKey: String,
        amount: Decimal,
        category: String,
        note: String = "",
        createdAt: Date = .now
    ) {
        self.dayKey = dayKey
        self.amount = amount
        self.category = category
        self.note = note
        self.createdAt = createdAt
    }
}
