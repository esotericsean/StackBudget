import SwiftUI

@main
struct StackBudgetApp: App {
    @StateObject private var budgetManager = BudgetManager()
    @StateObject private var recurringItemsManager = RecurringItemsManager()
    
    init() {
        // Force Light Mode
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.first?.overrideUserInterfaceStyle = .light
        }
    }
    
    private func createSampleBudget() {
        let startingBalance = Double.random(in: 1000...5000).rounded()
        let sampleItems = [
            BudgetItem(
                title: "Current Balance",
                amount: startingBalance,
                date: Date(),
                isCurrentBalance: true
            ),
            BudgetItem(
                title: "Paycheck",
                amount: 2000,
                date: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(),
                isInflux: true
            ),
            BudgetItem(
                title: "Rent",
                amount: 1200,
                date: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date(),
                isInflux: false
            ),
            BudgetItem(
                title: "Cellphone Bill",
                amount: 85,
                date: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
                isInflux: false
            ),
            BudgetItem(
                title: "Grocery Shopping",
                amount: 150,
                date: Calendar.current.date(byAdding: .day, value: 4, to: Date()) ?? Date(),
                isInflux: false
            )
        ]
        
        let sampleBudget = StackBudget(
            title: "Sample Budget",
            items: sampleItems,
            createdAt: Date(),
            colorName: Color.customPalette.randomElement()?.name ?? "Ocean"
        )
        
        budgetManager.addBudget(sampleBudget)
    }
    
    var body: some Scene {
        WindowGroup {
            BudgetListView()
                .environmentObject(budgetManager)
                .environmentObject(recurringItemsManager)
                .task {
                    if budgetManager.budgets.isEmpty && !UserDefaults.standard.bool(forKey: "didCreateInitialBudget") {
                        createSampleBudget()
                        UserDefaults.standard.set(true, forKey: "didCreateInitialBudget")
                    }
                }
                .preferredColorScheme(.light) // Force light mode at the SwiftUI level
        }
    }
}
