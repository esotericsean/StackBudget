import SwiftUI
import Foundation
import WidgetKit

struct LargeBudgetWidget: View {
    let budget: StackBudget
    
    private var recentTransactions: [BudgetItem] {
        Array(budget.items
            .filter { !$0.isCurrentBalance }
            .sorted { $0.date > $1.date }
            .prefix(4))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with current balance
            HStack {
                Text(budget.title)
                    .font(.headline)
                Spacer()
                Text(CurrencyFormatter.format(budget.currentBalance))
                    .font(.title2.bold())
                    .foregroundColor(budget.currentBalance >= 0 ? .green : .red)
            }
            
            Divider()
            
            // Recent transactions
            Text("Recent Activity")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if recentTransactions.isEmpty {
                Text("No recent activity")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                ForEach(Array(recentTransactions)) { item in
                    HStack {
                        Text(item.title)
                            .font(.subheadline)
                            .lineLimit(1)
                        Spacer()
                        Text(CurrencyFormatter.format(item.amount))
                            .font(.subheadline.bold())
                            .foregroundColor(item.isInflux ? .green : .red)
                    }
                }
            }
        }
        .padding()
    }
}

struct LargeBudgetWidget_Previews: PreviewProvider {
    static var previews: some View {
        LargeBudgetWidget(budget: .placeholder)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
} 