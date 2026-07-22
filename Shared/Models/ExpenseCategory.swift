import Foundation

enum ExpenseCategory: String, CaseIterable, Identifiable, Sendable {
    case food
    case transport
    case shopping
    case entertainment
    case other

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .food: "Food"
        case .transport: "Transport"
        case .shopping: "Shopping"
        case .entertainment: "Entertainment"
        case .other: "Other"
        }
    }

    var symbolName: String {
        switch self {
        case .food: "fork.knife"
        case .transport: "tram.fill"
        case .shopping: "bag.fill"
        case .entertainment: "gamecontroller.fill"
        case .other: "square.grid.2x2"
        }
    }
}
