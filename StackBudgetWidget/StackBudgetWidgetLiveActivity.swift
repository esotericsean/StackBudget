import ActivityKit
import WidgetKit
import SwiftUI

struct StackBudgetWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var value: Int
    }
    var name: String
}

@available(iOSApplicationExtension 16.1, *)
struct StackBudgetWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration<StackBudgetWidgetAttributes>(for: StackBudgetWidgetAttributes.self) { context in
            VStack {
                Text("Hello")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)
        } dynamicIsland: { context in
            DynamicIsland {
                // ... rest of the code ...
            }
        }
    }
} 