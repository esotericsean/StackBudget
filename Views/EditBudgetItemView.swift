import SwiftUI

struct EditBudgetItemView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var budgetManager: BudgetManager
    @Binding var budget: StackBudget
    let item: BudgetItem
    
    @State private var title: String
    @State private var amountString: String
    @State private var date: Date
    @State private var isInflux: Bool
    @State private var isLoading = false
    
    init(budget: Binding<StackBudget>, item: BudgetItem) {
        self._budget = budget
        self.item = item
        _title = State(initialValue: item.title)
        _amountString = State(initialValue: String(item.amount))
        _date = State(initialValue: item.date)
        _isInflux = State(initialValue: item.isInflux)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section {
                        TextField("Title", text: $title)
                            .font(AppTheme.bodyFont)
                        
                        AmountField(text: $amountString, placeholder: "Amount")
                        
                        DatePicker("Date", selection: $date, displayedComponents: .date)
                            .font(AppTheme.bodyFont)
                        
                        Toggle("Is Income", isOn: $isInflux)
                            .font(AppTheme.bodyFont)
                            .tint(AppTheme.primaryColor)
                    }
                    .listRowBackground(AppTheme.cardBackground)
                }
                .disabled(isLoading)
                
                if isLoading {
                    LoadingView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.2))
                }
            }
            .navigationTitle("Edit Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.primaryColor)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            await saveChanges()
                        }
                    }
                    .font(AppTheme.bodyFont.bold())
                    .foregroundColor(AppTheme.primaryColor)
                    .disabled(title.isEmpty || amountString.isEmpty || isLoading)
                }
            }
        }
    }
    
    private func saveChanges() async {
        isLoading = true
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        var updatedBudget = budget
        if let index = updatedBudget.items.firstIndex(where: { $0.id == item.id }) {
            var updatedItem = item
            updatedItem.title = title
            updatedItem.amount = Double(amountString) ?? 0
            updatedItem.date = date
            updatedItem.isInflux = isInflux
            
            updatedBudget.items[index] = updatedItem
            budget = updatedBudget
            budgetManager.updateBudget(updatedBudget)
            
            isLoading = false
            dismiss()
        }
    }
} 
