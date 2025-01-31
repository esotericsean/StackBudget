import Foundation

class SharedBudgetManager {
    static let shared = SharedBudgetManager()
    private let userDefaults = UserDefaults(suiteName: "group.com.yourapp.stackbudget")
    
    var budgets: [StackBudget] {
        get {
            guard let data = userDefaults?.data(forKey: "budgets"),
                  let budgets = try? JSONDecoder().decode([StackBudget].self, from: data) else {
                return []
            }
            return budgets
        }
    }
    
    func getLatestBudget() -> StackBudget {
        budgets.sorted { $0.createdAt > $1.createdAt }.first ?? .placeholder
    }
} 