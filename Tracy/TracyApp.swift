import SwiftData
import SwiftUI

@main
struct TracyApp: App {
    private let container = ModelContainerFactory.makeShared()

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(container)
    }
}
