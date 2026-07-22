import Foundation

/// This is a Simplified-Chinese-only app. Rather than depending on the user's
/// device language, we pin the locale and calendar so dates, month names, and
/// weekday symbols always render in Chinese. Inject `locale` into the SwiftUI
/// environment at the root of each UI surface (app and widget).
enum AppLocalization {
    static let localeIdentifier = "zh_Hans"

    static var locale: Locale {
        Locale(identifier: localeIdentifier)
    }

    /// The device calendar with its locale pinned to Chinese, so weekday
    /// symbols and month names come out localized while the user's own
    /// first-weekday / time-zone preferences are preserved.
    static var calendar: Calendar {
        var calendar = Calendar.current
        calendar.locale = locale
        return calendar
    }
}
