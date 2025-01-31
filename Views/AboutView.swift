import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    VStack(spacing: 16) {
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                            .padding(.top, 20)
                        
                        Text("StackBudget")
                            .font(.title.bold())
                        
                        Text("Version 1.0")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                }
                
                Section {
                    Text("StackBudget helps you track your monthly expenses and income with a simple, cheerful interface. Watch your savings grow month by month!")
                        .foregroundColor(.secondary)
                        .padding(.vertical, 8)
                }
                
                Section(header: Text("Features")) {
                    FeatureRow(icon: "repeat.circle.fill", title: "Recurring Items", description: "Automatically add regular expenses and income")
                    FeatureRow(icon: "paintpalette.fill", title: "Custom Themes", description: "Personalize each budget with colors")
                    FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Balance Tracking", description: "See your running balance for each transaction")
                }
                
                Section {
                    Text("Made with ❤️ in 2024")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.secondary)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
} 
