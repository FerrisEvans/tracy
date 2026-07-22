import SwiftData
import SwiftUI

struct PointsBadgeView: View {
    @Query private var events: [PointsEvent]

    private var total: Int {
        events.reduce(0) { $0 + $1.points }
    }

    var body: some View {
        // Not a Label: toolbars render Labels icon-only, hiding the count.
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
            Text("\(total)")
                .monospacedDigit()
        }
        .font(.subheadline.bold())
        .foregroundStyle(.orange)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Points: \(total)")
    }
}
