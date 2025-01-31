import Foundation
import SwiftUI

class BudgetManager: ObservableObject {
    @Published var budgets: [StackBudget] = []
    @Published var isLoading = false
    
    private let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedBudgets")
    
    init() {
        loadBudgets()
    }
    
    func addBudget(_ budget: StackBudget) {
        budgets.append(budget)
        saveBudgets()
    }
    
    func addBudget(_ title: String) {
        let newBudget = StackBudget(title: title)
        budgets.append(newBudget)
        saveBudgets()
    }
    
    func deleteBudget(_ budget: StackBudget) {
        if let index = budgets.firstIndex(where: { $0.id == budget.id }) {
            budgets.remove(at: index)
            saveBudgets()
        }
    }
    
    func updateBudget(_ budget: StackBudget) {
        if let index = budgets.firstIndex(where: { $0.id == budget.id }) {
            budgets[index] = budget
            saveBudgets()
        }
    }
    
    private func saveBudgets() {
        do {
            let data = try JSONEncoder().encode(budgets)
            try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save budgets: \(error.localizedDescription)")
        }
    }
    
    private func loadBudgets() {
        do {
            let data = try Data(contentsOf: savePath)
            budgets = try JSONDecoder().decode([StackBudget].self, from: data)
        } catch {
            budgets = []
        }
    }
}

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
} 
