import SwiftData
import SwiftUI
import WidgetKit

struct DiarySection: View {
    let dayKey: DayKey
    let entry: DiaryEntry?
    let onError: (String) -> Void

    @Environment(\.modelContext) private var context

    @State private var draft = ""
    @State private var justEarnedPoints = false

    private var trimmedDraft: String {
        draft.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        Section("Diary") {
            TextEditor(text: $draft)
                .frame(minHeight: 120)
                .accessibilityLabel("Diary text")
            HStack {
                if justEarnedPoints {
                    Label("+\(PointsService.pointsPerDiary)", systemImage: "star.fill")
                        .foregroundStyle(.orange)
                        .font(.caption.bold())
                        .transition(.scale.combined(with: .opacity))
                }
                Spacer()
                Button("Save") { save() }
                    .disabled(trimmedDraft.isEmpty)
            }
        }
        .onAppear {
            draft = entry?.content ?? ""
        }
    }

    private func save() {
        let text = trimmedDraft
        guard !text.isEmpty else { return }
        do {
            if let entry {
                entry.content = text
                entry.updatedAt = .now
            } else {
                context.insert(DiaryEntry(dayKey: dayKey.value, content: text))
                let awarded = try PointsService(context: context)
                    .awardDiaryCreationPoints(for: dayKey)
                if awarded != nil {
                    withAnimation { justEarnedPoints = true }
                }
            }
            try context.save()
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            onError("Could not save the diary entry. Please try again.")
        }
    }
}
