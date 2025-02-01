import WidgetKit
import SwiftUI
import StackBudgetShared

struct SimpleEntry: TimelineEntry {
    let date: Date
    let budget: StackBudget
}

struct Provider: TimelineProvider {
    typealias Entry = SimpleEntry
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), budget: StackBudget.placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), budget: StackBudget.placeholder)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let entries = [SimpleEntry(date: Date(), budget: StackBudget.placeholder)]
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

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

struct BudgetWidget: Widget {
    let kind: String = "BudgetWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BudgetWidgetView(entry: entry)
        }
        .configurationDisplayName("Budget Status")
        .description("Shows your current budget balance")
        .supportedFamilies([.systemSmall])
    }
}

#if DEBUG
struct BudgetWidget_Previews: PreviewProvider {
    static var previews: some View {
        BudgetWidgetView(entry: SimpleEntry(date: Date(), budget: StackBudget.placeholder))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
#endif 