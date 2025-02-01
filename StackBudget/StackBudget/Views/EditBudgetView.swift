import SwiftUI

struct EditBudgetView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var budgetManager: BudgetManager
    @Binding var budget: StackBudget
    
    @State private var title: String
    @State private var selectedColorName: String
    @State private var showingDeleteConfirmation = false
    @State private var isLoading = false
    @State private var showingClearConfirmation = false
    
    init(budget: Binding<StackBudget>) {
        self._budget = budget
        _title = State(initialValue: budget.wrappedValue.title)
        _selectedColorName = State(initialValue: budget.wrappedValue.colorName)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section {
                        TextField("Budget Title", text: $title)
                            .font(AppTheme.bodyFont)
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
                    
                    Section {
                        Button(role: .destructive) {
                            showingClearConfirmation = true
                        } label: {
                            HStack {
                                Spacer()
                                Text("Clear Budget")
                                    .font(AppTheme.bodyFont)
                                Spacer()
                            }
                        }
                    }
                    .listRowBackground(AppTheme.cardBackground)
                    
                    Section {
                        Button(role: .destructive) {
                            showingDeleteConfirmation = true
                        } label: {
                            HStack {
                                Spacer()
                                Text("Delete Budget")
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
            .navigationTitle("Edit Budget")
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
                    .disabled(title.isEmpty || isLoading)
                }
            }
            .alert("Clear Budget", isPresented: $showingClearConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Clear", role: .destructive) {
                    clearBudget()
                }
            } message: {
                Text("This will remove all items and set the balance to $0.00. This cannot be undone.")
            }
            .alert("Delete Budget", isPresented: $showingDeleteConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    budgetManager.deleteBudget(budget)
                    dismiss()
                }
            } message: {
                Text("Are you sure you want to delete this budget? This cannot be undone.")
            }
        }
    }
    
    private func saveChanges() async {
        isLoading = true
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        var updatedBudget = budget
        updatedBudget.title = title
        updatedBudget.colorName = selectedColorName
        budget = updatedBudget
        budgetManager.updateBudget(updatedBudget)
        
        isLoading = false
        dismiss()
    }
    
    private func clearBudget() {
        var updatedBudget = budget
        updatedBudget.items = [
            BudgetItem(
                title: "Current Balance",
                amount: 0,
                date: Date(),
                isCurrentBalance: true
            )
        ]
        budget = updatedBudget
        budgetManager.updateBudget(updatedBudget)
        dismiss()
    }
} 