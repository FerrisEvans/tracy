import SwiftUI

struct RootView: View {
    var body: some View {
        NavigationStack {
            CalendarScreen()
                .navigationTitle("Tracy")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        PointsBadgeView()
                    }
                }
        }
        .environment(\.locale, AppLocalization.locale)
    }
}

#Preview {
    RootView()
        .modelContainer(ModelContainerFactory.makeInMemory())
}
