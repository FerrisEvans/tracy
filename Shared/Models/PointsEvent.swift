import Foundation
import SwiftData

/// Why points were granted. Stored as a raw string on `PointsEvent`.
enum PointsReason: String, Sendable {
    case diaryCreated
}

/// Append-only ledger of earned points. The current balance is the sum of
/// all events — no mutable counter to keep consistent.
@Model
final class PointsEvent {
    var dayKey: String = ""
    var points: Int = 0
    var reason: String = ""
    var createdAt: Date = Date()

    init(
        dayKey: String,
        points: Int,
        reason: String,
        createdAt: Date = .now
    ) {
        self.dayKey = dayKey
        self.points = points
        self.reason = reason
        self.createdAt = createdAt
    }
}
