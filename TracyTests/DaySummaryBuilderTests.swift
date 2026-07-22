import Foundation
import Testing
@testable import Tracy

struct DaySummaryBuilderTests {
    @Test func emptyInputsProduceEmptyMap() {
        let summaries = DaySummaryBuilder.build(diaryDayKeys: [], expenseDayKeys: [])
        #expect(summaries.isEmpty)
    }

    @Test func diaryOnlyDayHasOnlyDiaryFlag() {
        let summaries = DaySummaryBuilder.build(
            diaryDayKeys: ["2026-07-01"],
            expenseDayKeys: []
        )
        #expect(summaries["2026-07-01"] == DaySummary(hasDiary: true, hasExpense: false))
    }

    @Test func sameDayMergesBothFlags() {
        let summaries = DaySummaryBuilder.build(
            diaryDayKeys: ["2026-07-01"],
            expenseDayKeys: ["2026-07-01", "2026-07-02"]
        )
        #expect(summaries["2026-07-01"] == DaySummary(hasDiary: true, hasExpense: true))
        #expect(summaries["2026-07-02"] == DaySummary(hasDiary: false, hasExpense: true))
    }

    @Test func duplicateKeysCollapse() {
        let summaries = DaySummaryBuilder.build(
            diaryDayKeys: ["2026-07-01", "2026-07-01"],
            expenseDayKeys: ["2026-07-01", "2026-07-01", "2026-07-01"]
        )
        #expect(summaries.count == 1)
    }
}
