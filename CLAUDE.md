# Tracy

Diary + expense-tracking iOS app for the App Store. Calendar-first UI:
the main screen is a month grid; days with data show marker icons; tapping
a day opens diary + expense editing. Local points reward diary writing.

## Architecture decisions (do not revisit without asking)

- Swift + SwiftUI, minimum iOS 17. No Objective-C, no UIKit unless bridging.
- No backend, no accounts. All data is local SwiftData; sync/backup will be
  iCloud/CloudKit (`cloudKitDatabase: .automatic`) once signing is set up.
- Points are local-only and fun-only — tamper-resistance is a non-goal.
- Widget shares the SwiftData store via App Group `group.com.ferris.tracy`.

## Project layout

- `project.yml` — XcodeGen manifest, the source of truth. The `.xcodeproj`
  is gitignored; regenerate it after target/file changes.
- `Shared/` — models + pure logic compiled into both app and widget.
- `Tracy/` — app target (views, services).
- `TracyWidget/` — WidgetKit extension.
- `TracyTests/` — Swift Testing unit tests (host app: Tracy).

## Commands

```bash
xcodegen generate                 # regenerate Tracy.xcodeproj from project.yml
xcodebuild -project Tracy.xcodeproj -scheme Tracy \
  -destination 'platform=iOS Simulator,name=iPhone 17' build
xcodebuild -project Tracy.xcodeproj -scheme Tracy \
  -destination 'platform=iOS Simulator,name=iPhone 17' test
```

## Conventions

- Records are keyed by `DayKey` ("yyyy-MM-dd" string) — never store bare
  Dates for day grouping.
- SwiftData models must stay CloudKit-compatible: every property has a
  default, no `@Attribute(.unique)`.
- After any data write in the app, call
  `WidgetCenter.shared.reloadAllTimelines()`.
- New date/grid logic goes in `Shared/Support` as pure functions with tests.
