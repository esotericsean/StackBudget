import SwiftUI

struct EditRecurringItemView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var recurringItemsManager: RecurringItemsManager
    
    let item: BudgetItem
    @State private var title = ""
    @State private var amount = 0.0
    @State private var recurringDay = 1
    @State private var isInflux = false
    @State private var showingSuccessMessage = false
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
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
                
                HStack {
                    Text("Day of Month")
                        .font(AppTheme.bodyFont)
                    Spacer()
                    Picker("", selection: $recurringDay) {
                        ForEach(1...31, id: \.self) { day in
                            Text("\(day)").tag(day)
                        }
                    }
                    .font(AppTheme.bodyFont)
                }
                
                Toggle("Is Income", isOn: $isInflux)
                    .font(AppTheme.bodyFont)
                    .tint(AppTheme.primaryColor)
            }
            .listRowBackground(AppTheme.cardBackground)
            
            Section {
                Button(role: .destructive) {
                    showingDeleteConfirmation = true
                } label: {
                    HStack {
                        Spacer()
                        Text("Delete Recurring Item")
                            .font(AppTheme.bodyFont)
                        Spacer()
                    }
                }
            }
            .listRowBackground(AppTheme.cardBackground)
        }
        .navigationTitle("Edit Recurring Item")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveChanges()
                }
                .font(AppTheme.bodyFont.bold())
                .foregroundColor(AppTheme.primaryColor)
                .disabled(title.isEmpty || amount == 0)
            }
        }
        .overlay {
            if showingSuccessMessage {
                SuccessMessage(message: "Changes Saved!")
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .alert("Delete Recurring Item", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                recurringItemsManager.removeItem(item)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this recurring item? This cannot be undone.")
        }
        .onAppear {
            title = item.title
            amount = item.amount
            recurringDay = item.recurringDay ?? 1
            isInflux = item.isInflux
        }
    }
    
    private func saveChanges() {
        var updatedItem = item
        updatedItem.title = title
        updatedItem.amount = amount
        updatedItem.recurringDay = recurringDay
        updatedItem.isInflux = isInflux
        
        recurringItemsManager.updateItem(updatedItem)
        
        withAnimation {
            showingSuccessMessage = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            dismiss()
        }
    }
} 