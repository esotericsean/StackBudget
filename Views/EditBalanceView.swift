import SwiftUI

struct EditBalanceView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var budgetManager: BudgetManager
    @Binding var budget: StackBudget
    let currentAmount: Double
    
    @State private var amount: Double
    @State private var showingDeleteConfirmation = false
    @State private var isLoading = false
    
    init(budget: Binding<StackBudget>, currentAmount: Double) {
        self._budget = budget
        self.currentAmount = currentAmount
        _amount = State(initialValue: currentAmount)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section {
                        HStack {
                            Text("Amount")
                                .font(AppTheme.bodyFont)
                            Spacer()
                            TextField("Amount", value: $amount, format: .currency(code: "USD"))
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .font(AppTheme.bodyFont)
                        }
                    }
                    .listRowBackground(AppTheme.cardBackground)
                    
                    if amount != currentAmount {
                        Section {
                            HStack {
                                Text("Change:")
                                    .font(AppTheme.subheadlineFont)
                                Spacer()
                                Text(formatChange(amount - currentAmount))
                                    .font(AppTheme.subheadlineFont)
                                    .foregroundColor(amount >= currentAmount ? AppTheme.successColor : AppTheme.warningColor)
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
                        Task {
                            await saveChanges()
                        }
                    }
                    .font(AppTheme.bodyFont.bold())
                    .foregroundColor(AppTheme.primaryColor)
                    .disabled(isLoading)
                }
            }
            .alert("Reset Balance", isPresented: $showingDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    amount = 0
                    Task {
                        await saveChanges()
                    }
                }
            } message: {
                Text("Are you sure you want to reset the balance to $0.00?")
            }
        }
    }
    
    private func saveChanges() async {
        isLoading = true
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        var updatedBudget = budget
        if let index = updatedBudget.items.firstIndex(where: { $0.isCurrentBalance }) {
            updatedBudget.items[index].amount = amount
            budget = updatedBudget
            budgetManager.updateBudget(updatedBudget)
            
            isLoading = false
            dismiss()
        }
    }
    
    private func formatChange(_ change: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        let formattedAmount = formatter.string(from: NSNumber(value: abs(change))) ?? "$0.00"
        return change >= 0 ? "+\(formattedAmount)" : "-\(formattedAmount)"
    }
} 
