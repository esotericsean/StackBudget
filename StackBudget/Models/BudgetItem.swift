import Foundation

struct BudgetItem: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var amount: Double
    var date: Date
    var isCurrentBalance: Bool
    var isInflux: Bool
    var isRecurring: Bool
    var recurringDay: Int?
    
    init(id: UUID = UUID(), title: String, amount: Double, date: Date, isCurrentBalance: Bool = false, isInflux: Bool = false, isRecurring: Bool = false, recurringDay: Int? = nil) {
        self.id = id
        self.title = title
        self.amount = amount
        self.date = date
        self.isCurrentBalance = isCurrentBalance
        self.isInflux = isInflux
        self.isRecurring = isRecurring
        self.recurringDay = recurringDay
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: abs(amount))) ?? "$0.00"
    }
    
    var impact: Double {
        isInflux ? amount : -amount
    }
} 
