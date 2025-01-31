import Foundation
import SwiftUI

struct StackBudget: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var items: [BudgetItem]
    var createdAt: Date
    var colorName: String  // Store the color name instead of Color directly
    
    init(id: UUID = UUID(), title: String, items: [BudgetItem] = [
        BudgetItem(title: "Current Balance", amount: 0, date: Date(), isCurrentBalance: true)
    ], createdAt: Date = Date(), colorName: String = "Sky") {
        self.id = id
        self.title = title
        self.items = items
        self.createdAt = createdAt
        self.colorName = colorName
    }
    
    var color: Color {
        if let colorPair = Color.customPalette.first(where: { $0.name == colorName }) {
            return colorPair.main
        }
        return Color.randomPaletteColor
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: createdAt)
    }
} 