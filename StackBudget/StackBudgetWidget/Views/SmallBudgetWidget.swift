import SwiftUI
import Foundation
import WidgetKit

struct SmallBudgetWidget: View {
    let budget: StackBudget
    
    var body: some View {
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
        .padding()
    }
}

struct SmallBudgetWidget_Previews: PreviewProvider {
    static var previews: some View {
        SmallBudgetWidget(budget: .placeholder)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Small Widget")
    }
} 