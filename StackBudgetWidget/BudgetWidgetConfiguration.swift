import WidgetKit
import SwiftUI

struct BudgetWidgetConfiguration: Widget {
    let kind: String = "BudgetWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration<SimpleEntry>(kind: kind, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Budget Status")
        .description("Shows your current budget balance")
        .supportedFamilies([.systemSmall])
    }
} 