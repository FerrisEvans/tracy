import Foundation
import SwiftData

/// One diary entry per day. All properties carry defaults so the schema
/// stays CloudKit-compatible (CloudKit forbids required fields without
/// defaults and unique constraints).
@Model
final class DiaryEntry {
    var dayKey: String = ""
    var content: String = ""
    var createdAt: Date = Date()
    var updatedAt: Date = Date()

    init(
        dayKey: String,
        content: String,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.dayKey = dayKey
        self.content = content
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
