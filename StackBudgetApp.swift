import SwiftUI

@main
struct StackBudgetApp: App {
    @StateObject private var budgetManager = BudgetManager()
    @StateObject private var recurringItemsManager = RecurringItemsManager()
    
    var body: some Scene {
        WindowGroup {
            BudgetListView()
                .environmentObject(budgetManager)
                .environmentObject(recurringItemsManager)
                .task {
                    if budgetManager.budgets.isEmpty && !UserDefaults.standard.bool(forKey: "didCreateInitialBudget") {
                        budgetManager.addBudget("My First Budget")
                        UserDefaults.standard.set(true, forKey: "didCreateInitialBudget")
                    }
                }
        }
    }
} 
