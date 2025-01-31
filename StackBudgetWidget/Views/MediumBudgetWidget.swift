import SwiftUI
import Foundation
import WidgetKit

struct MediumBudgetWidget: View {
    let budget: StackBudget
    
    var body: some View {
        HStack {
            // Left side - Current Balance
            VStack(alignment: .leading, spacing: 8) {
                Text(budget.title)
                    .font(.headline)
                
                Spacer()
                
                Text("Current Balance")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(CurrencyFormatter.format(budget.currentBalance))
                    .font(.title2.bold())
                    .foregroundColor(budget.currentBalance >= 0 ? .green : .red)
            }
            
            Divider()
                .padding(.horizontal)
            
            // Right side - Final Balance
            VStack(alignment: .leading, spacing: 8) {
                Text("Recent Activity")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if let lastItem = budget.items.filter({ !$0.isCurrentBalance }).sorted(by: { $0.date > $1.date }).first {
                    Text(lastItem.title)
                        .font(.subheadline)
                        .lineLimit(1)
                    
                    Text(CurrencyFormatter.format(lastItem.amount))
                        .font(.title3.bold())
                        .foregroundColor(lastItem.isInflux ? .green : .red)
                } else {
                    Text("No recent activity")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
    }
}

struct MediumBudgetWidget_Previews: PreviewProvider {
    static var previews: some View {
        MediumBudgetWidget(budget: .placeholder)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("Medium Widget")
    }
} 