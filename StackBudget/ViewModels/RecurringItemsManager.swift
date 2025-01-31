import Foundation

class RecurringItemsManager: ObservableObject {
    @Published var recurringItems: [BudgetItem] = []
    private let savePath = FileManager.documentsDirectory.appendingPathComponent("RecurringItems")
    
    init() {
        loadItems()
    }
    
    func addItem(_ item: BudgetItem) {
        var updatedItem = item
        updatedItem.isRecurring = true
        recurringItems.append(updatedItem)
        saveItems()
    }
    
    func removeItem(_ item: BudgetItem) {
        if let index = recurringItems.firstIndex(where: { $0.id == item.id }) {
            recurringItems.remove(at: index)
            saveItems()
        }
    }
    
    func updateItem(_ item: BudgetItem) {
        if let index = recurringItems.firstIndex(where: { $0.id == item.id }) {
            recurringItems[index] = item
            saveItems()
        }
    }
    
    private func saveItems() {
        do {
            let data = try JSONEncoder().encode(recurringItems)
            try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save recurring items: \(error.localizedDescription)")
        }
    }
    
    private func loadItems() {
        do {
            let data = try Data(contentsOf: savePath)
            recurringItems = try JSONDecoder().decode([BudgetItem].self, from: data)
        } catch {
            recurringItems = []
        }
    }
} 