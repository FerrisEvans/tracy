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
        case .food: "餐饮"
        case .transport: "交通"
        case .shopping: "购物"
        case .entertainment: "娱乐"
        case .other: "其他"
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
