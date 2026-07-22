import Foundation
import SwiftData

/// Rules for earning points. Points are a local, fun-only reward —
/// they are never money and never leave the device.
struct PointsService {
    static let pointsPerDiary = 10

    let context: ModelContext

    func totalPoints() throws -> Int {
        try context.fetch(FetchDescriptor<PointsEvent>())
            .reduce(0) { $0 + $1.points }
    }

    /// Awards diary-creation points at most once per day.
    /// Returns `nil` when that day was already rewarded.
    @discardableResult
    func awardDiaryCreationPoints(for dayKey: DayKey) throws -> PointsEvent? {
        let key = dayKey.value
        let reason = PointsReason.diaryCreated.rawValue

        var descriptor = FetchDescriptor<PointsEvent>(
            predicate: #Predicate { $0.dayKey == key && $0.reason == reason }
        )
        descriptor.fetchLimit = 1
        guard try context.fetch(descriptor).isEmpty else { return nil }

        let event = PointsEvent(dayKey: key, points: Self.pointsPerDiary, reason: reason)
        context.insert(event)
        try context.save()
        return event
    }
}
