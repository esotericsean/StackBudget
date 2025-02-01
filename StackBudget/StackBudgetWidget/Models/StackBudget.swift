import Foundation

struct StackBudget: Identifiable, Codable {
    let id: UUID
    var title: String
    var items: [BudgetItem]
    var createdAt: Date
    var colorName: String
    
    var currentBalance: Double {
        items.first(where: { $0.isCurrentBalance })?.amount ?? 0
    }
    
    static var placeholder: StackBudget {
        StackBudget(
            id: UUID(),
            title: "Sample Budget",
            items: [
                BudgetItem(
                    title: "Current Balance",
                    amount: 1000,
                    date: Date(),
                    isCurrentBalance: true
                )
            ],
            createdAt: Date(),
            colorName: "Blue"
        )
    }
}

struct BudgetItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var amount: Double
    var date: Date
    var isInflux: Bool
    var isCurrentBalance: Bool
    var recurringDay: Int?
    
    init(
        id: UUID = UUID(),
        title: String,
        amount: Double,
        date: Date,
        isInflux: Bool = false,
        isCurrentBalance: Bool = false,
        recurringDay: Int? = nil
    ) {
        self.id = id
        self.title = title
        self.amount = amount
        self.date = date
        self.isInflux = isInflux
        self.isCurrentBalance = isCurrentBalance
        self.recurringDay = recurringDay
    }
} 