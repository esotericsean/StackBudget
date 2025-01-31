import SwiftUI
import WidgetKit

struct BudgetWidgetView: View {
    let entry: SimpleEntry
    
    var body: some View {
        VStack {
            Text("Budget: \(entry.budget.title)")
            Text("Balance: \(entry.budget.currentBalance, format: .currency(code: "USD"))")
        }
        .padding()
    }
}

struct BudgetWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetWidgetView(entry: SimpleEntry(date: Date(), budget: .placeholder))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
} 