import SwiftUI
import StackBudgetShared

struct AddBudgetItemView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var budgetManager: BudgetManager
    @EnvironmentObject var recurringItemsManager: RecurringItemsManager
    @Binding var budget: StackBudget
    
    @State private var title = ""
    @State private var amount = 0.0
    @State private var date = Date()
    @State private var isInflux = false
    @State private var isRecurring = false
    @State private var showingSuccessMessage = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $title)
                        .font(AppTheme.bodyFont)
                    
                    HStack {
                        Text("Amount")
                            .font(AppTheme.bodyFont)
                        Spacer()
                        TextField("Amount", value: $amount, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .font(AppTheme.bodyFont)
                    }
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .font(AppTheme.bodyFont)
                    
                    Toggle("Is Income", isOn: $isInflux)
                        .font(AppTheme.bodyFont)
                        .tint(AppTheme.primaryColor)
                    
                    Toggle("Is Recurring", isOn: $isRecurring)
                        .font(AppTheme.bodyFont)
                        .tint(AppTheme.primaryColor)
                }
                .listRowBackground(AppTheme.cardBackground)
                
                if isRecurring {
                    Section {
                        Text("This item will be added to all future budgets on day \(Calendar.current.component(.day, from: date))")
                            .font(AppTheme.subheadlineFont)
                            .foregroundColor(.secondary)
                    }
                    .listRowBackground(AppTheme.cardBackground)
                }
            }
            .navigationTitle(isInflux ? "Add Income" : "Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.primaryColor)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        addItem()
                    }
                    .font(AppTheme.bodyFont.bold())
                    .foregroundColor(AppTheme.primaryColor)
                    .disabled(title.isEmpty || amount == 0)
                }
            }
            .overlay {
                if showingSuccessMessage {
                    SuccessMessage()
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
    }
    
    private func addItem() {
        let selectedDay = Calendar.current.component(.day, from: date)
        let newItem = BudgetItem(
            title: title,
            amount: amount,
            date: date,
            isInflux: isInflux,
            isRecurring: isRecurring,
            recurringDay: isRecurring ? selectedDay : nil
        )
        
        if isRecurring {
            recurringItemsManager.addItem(newItem)
        }
        
        var updatedBudget = budget
        updatedBudget.items.append(newItem)
        budget = updatedBudget
        budgetManager.updateBudget(updatedBudget)
        
        withAnimation {
            showingSuccessMessage = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            dismiss()
        }
    }
}

struct AddBudgetItemView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleBudget = StackBudget(title: "Preview Budget")
        return AddBudgetItemView(budget: .constant(sampleBudget))
            .environmentObject(BudgetManager())
            .environmentObject(RecurringItemsManager())
    }
} 
