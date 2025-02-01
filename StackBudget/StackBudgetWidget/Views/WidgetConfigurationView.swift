import SwiftUI
import WidgetKit

struct WidgetConfigurationView: View {
    @AppStorage("widgetConfig", store: UserDefaults(suiteName: "group.com.yourapp.stackbudget"))
    private var configData: Data = try! JSONEncoder().encode(WidgetConfiguration.default)
    
    @State private var config: WidgetConfiguration
    let budgetManager = SharedBudgetManager.shared
    
    init() {
        let decoder = JSONDecoder()
        _config = State(initialValue: (try? decoder.decode(WidgetConfiguration.self, from: configData)) ?? .default)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Budget")) {
                Picker("Select Budget", selection: $config.selectedBudgetId) {
                    Text("Latest Budget").tag(nil as UUID?)
                    ForEach(budgetManager.budgets) { budget in
                        Text(budget.title).tag(budget.id as UUID?)
                    }
                }
            }
            
            Section(header: Text("Display Options")) {
                Toggle("Show Balance", isOn: $config.showBalance)
                Toggle("Show Transactions", isOn: $config.showTransactions)
            }
        }
        .onChange(of: config) { newConfig in
            if let encoded = try? JSONEncoder().encode(newConfig) {
                configData = encoded
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
} 