import Foundation

struct WidgetConfiguration: Codable, Equatable {
    var selectedBudgetId: UUID?
    var showBalance: Bool = true
    var showTransactions: Bool = true
    
    static let `default` = WidgetConfiguration()
} 