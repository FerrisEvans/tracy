import Foundation
import SwiftData
import Testing
@testable import Tracy

@MainActor
struct PointsServiceTests {
    private func makeService() -> PointsService {
        PointsService(context: ModelContext(ModelContainerFactory.makeInMemory()))
    }

    @Test func startsAtZeroPoints() throws {
        let service = makeService()
        #expect(try service.totalPoints() == 0)
    }

    @Test func awardsPointsForFirstDiaryOfTheDay() throws {
        let service = makeService()
        let event = try service.awardDiaryCreationPoints(for: DayKey(value: "2026-07-22"))
        #expect(event?.points == PointsService.pointsPerDiary)
        #expect(try service.totalPoints() == PointsService.pointsPerDiary)
    }

    @Test func doesNotAwardTwiceForTheSameDay() throws {
        let service = makeService()
        let day = DayKey(value: "2026-07-22")
        try service.awardDiaryCreationPoints(for: day)
        let second = try service.awardDiaryCreationPoints(for: day)
        #expect(second == nil)
        #expect(try service.totalPoints() == PointsService.pointsPerDiary)
    }

    @Test func awardsIndependentlyPerDay() throws {
        let service = makeService()
        try service.awardDiaryCreationPoints(for: DayKey(value: "2026-07-21"))
        try service.awardDiaryCreationPoints(for: DayKey(value: "2026-07-22"))
        #expect(try service.totalPoints() == PointsService.pointsPerDiary * 2)
    }
}
