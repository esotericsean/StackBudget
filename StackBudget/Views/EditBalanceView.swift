import SwiftUI

struct EditBalanceView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var budgetManager: BudgetManager
    @Binding var budget: StackBudget
    let currentAmount: Double
    
    @State private var amountString: String = ""
    @State private var isEditing: Bool = false
    @FocusState private var isFocused: Bool
    @State private var showingDeleteConfirmation = false
    @State private var isLoading = false
    @State private var previousAmount: String = ""
    
    init(budget: Binding<StackBudget>, currentAmount: Double) {
        self._budget = budget
        self.currentAmount = currentAmount
        _amountString = State(initialValue: formatCurrency(currentAmount))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section {
                        AmountField(text: $amountString, placeholder: "Amount")
                    }
                    .listRowBackground(AppTheme.cardBackground)
                    
                    let newAmount = parseAmount(from: amountString)
                    if newAmount != currentAmount {
                        Section {
                            HStack {
                                Text("Change:")
                                    .font(AppTheme.subheadlineFont)
                                Spacer()
                                Text(formatChange(newAmount - currentAmount))
                                    .font(AppTheme.subheadlineFont)
                                    .foregroundColor(newAmount >= currentAmount ? AppTheme.successColor : AppTheme.warningColor)
                            }
                            .listRowBackground(AppTheme.cardBackground)
                        }
                    }
                    
                    Section {
                        Button(role: .destructive) {
                            showingDeleteConfirmation = true
                        } label: {
                            HStack {
                                Spacer()
                                Text("Reset Balance")
                                    .font(AppTheme.bodyFont)
                                Spacer()
                            }
                        }
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
            .navigationTitle("Edit Balance")
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
                        saveChanges()
                    }
                    .font(AppTheme.bodyFont.bold())
                    .foregroundColor(AppTheme.primaryColor)
                    .disabled(isLoading)
                }
            }
            .alert("Reset Balance", isPresented: $showingDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    amountString = formatCurrency(0)
                    saveChanges()
                }
            } message: {
                Text("Are you sure you want to reset the balance to $0.00?")
            }
        }
    }
    
    private func saveChanges() {
        let newAmount = parseAmount(from: amountString)
        if newAmount != currentAmount {
            if let firstIndex = budget.items.firstIndex(where: { $0.isCurrentBalance }) {
                var updatedBudget = budget
                updatedBudget.items[firstIndex].amount = newAmount
                budget = updatedBudget
                budgetManager.updateBudget(updatedBudget)
            }
        }
        dismiss()
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return (formatter.string(from: NSNumber(value: amount)) ?? "$0.00")
            .replacingOccurrences(of: "$", with: "")
    }
    
    private func parseAmount(from string: String) -> Double {
        if string.isEmpty {
            return currentAmount
        }
        let cleanedString = string.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)
        return Double(cleanedString) ?? currentAmount
    }
    
    private func formatChange(_ change: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        let formattedAmount = formatter.string(from: NSNumber(value: abs(change))) ?? "$0.00"
        return change >= 0 ? "+\(formattedAmount)" : "-\(formattedAmount)"
    }
}
