import Foundation

public struct StackBudget {
    public let title: String
    public let currentBalance: Double
    
    public static let placeholder = StackBudget(title: "Sample Budget", currentBalance: 1000)
    
    public init(title: String, currentBalance: Double) {
        self.title = title
        self.currentBalance = currentBalance
    }
} 