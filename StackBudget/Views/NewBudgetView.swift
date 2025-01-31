import SwiftUI

struct NewBudgetView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var budgetManager: BudgetManager
    @EnvironmentObject var recurringItemsManager: RecurringItemsManager
    
    @State private var title = ""
    @State private var initialBalance = 0.0
    @State private var includeRecurring = true
    @State private var budgetMonth = Date()
    @State private var selectedColorName = Color.customPalette[0].name
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section {
                        TextField("Budget Title", text: $title)
                            .font(AppTheme.bodyFont)
                        
                        HStack {
                            Text("Current Balance")
                                .font(AppTheme.bodyFont)
                            Spacer()
                            TextField("Amount", value: $initialBalance, format: .currency(code: "USD"))
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .font(AppTheme.bodyFont)
                        }
                    }
                    .listRowBackground(AppTheme.cardBackground)
                    
                    Section(header: Text("Theme Color")) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppTheme.spacing) {
                                ForEach(Color.customPalette, id: \.name) { colorPair in
                                    ColorPickerItem(
                                        color: colorPair.main,
                                        name: colorPair.name,
                                        isSelected: selectedColorName == colorPair.name,
                                        action: {
                                            selectedColorName = colorPair.name
                                        }
                                    )
                                }
                            }
                            .padding(.vertical, AppTheme.smallSpacing)
                        }
                    }
                    .listRowBackground(AppTheme.cardBackground)
                    
                    if !recurringItemsManager.recurringItems.isEmpty {
                        Section {
                            Toggle("Include Recurring Items", isOn: $includeRecurring)
                                .font(AppTheme.bodyFont)
                                .tint(AppTheme.primaryColor)
                            
                            if includeRecurring {
                                ForEach(recurringItemsManager.recurringItems) { item in
                                    HStack {
                                        Text(item.title)
                                            .font(AppTheme.bodyFont)
                                        Spacer()
                                        Text(item.formattedAmount)
                                            .font(AppTheme.bodyFont)
                                            .foregroundColor(item.isInflux ? AppTheme.successColor : AppTheme.warningColor)
                                    }
                                }
                            }
                        }
                        .listRowBackground(AppTheme.cardBackground)
                    }
                }
                .disabled(isLoading)
                
                if isLoading {
                    LoadingView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.2))
                }
            }
            .navigationTitle("New Budget")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.primaryColor)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        Task {
                            await createBudget()
                        }
                    }
                    .font(AppTheme.bodyFont.bold())
                    .foregroundColor(AppTheme.primaryColor)
                    .disabled(title.isEmpty || isLoading)
                }
            }
        }
    }
    
    private func createBudget() async {
        isLoading = true
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        var items = [
            BudgetItem(
                title: "Current Balance",
                amount: initialBalance,
                date: budgetMonth,
                isCurrentBalance: true
            )
        ]
        
        if includeRecurring {
            let calendar = Calendar.current
            for item in recurringItemsManager.recurringItems {
                var components = calendar.dateComponents([.year, .month], from: budgetMonth)
                components.day = item.recurringDay
                
                if let itemDate = calendar.date(from: components) {
                    var recurringItem = item
                    recurringItem.date = itemDate
                    items.append(recurringItem)
                }
            }
        }
        
        let newBudget = StackBudget(
            title: title,
            items: items,
            createdAt: Date(),
            colorName: selectedColorName
        )
        
        budgetManager.addBudget(newBudget)
        
        isLoading = false
        dismiss()
    }
} 