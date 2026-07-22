import Foundation
import SwiftData

enum ModelContainerFactory {
    /// Must match the App Group in both targets' entitlements.
    static let appGroupID = "group.com.ferris.tracy"

    static let schema = Schema([
        DiaryEntry.self,
        ExpenseRecord.self,
        PointsEvent.self,
    ])

    /// Store shared between the app and the widget via the App Group
    /// container. CloudKit sync stays `.none` until the iCloud capability
    /// and container are configured in the developer account — then switch
    /// to `.automatic` (the models are already CloudKit-compatible).
    static func makeShared() -> ModelContainer {
        ensureAppGroupStoreDirectoryExists()
        let grouped = ModelConfiguration(
            "Tracy",
            schema: schema,
            groupContainer: .identifier(appGroupID),
            cloudKitDatabase: .none
        )
        do {
            return try ModelContainer(for: schema, configurations: [grouped])
        } catch {
            // Fall back to a local store so the app still launches when the
            // App Group entitlement is unavailable (e.g. fresh signing setup).
            let local = ModelConfiguration("Tracy", schema: schema, cloudKitDatabase: .none)
            do {
                return try ModelContainer(for: schema, configurations: [local])
            } catch {
                fatalError("Unable to create any persistent store: \(error)")
            }
        }
    }

    /// SwiftData puts the store in `Library/Application Support` inside the
    /// App Group container, but never creates that directory on a fresh
    /// install — CoreData then logs a scary error before recovering. Creating
    /// it up front keeps first launch clean. Failure here is non-fatal:
    /// CoreData's own recovery still kicks in.
    private static func ensureAppGroupStoreDirectoryExists() {
        guard let base = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroupID)
        else { return }
        let supportDirectory = base.appending(path: "Library/Application Support")
        try? FileManager.default.createDirectory(
            at: supportDirectory,
            withIntermediateDirectories: true
        )
    }

    /// In-memory store for tests and previews.
    static func makeInMemory() -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Unable to create in-memory store: \(error)")
        }
    }
}
