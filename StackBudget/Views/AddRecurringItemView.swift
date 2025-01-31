import SwiftUI

struct AddRecurringItemView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var recurringItemsManager: RecurringItemsManager
    
    @State private var title = ""
    @State private var amount = 0.0
    @State private var recurringDay = 1
    @State private var isInflux = false
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
            }
            .navigationTitle("Add Recurring Item")
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
                    SuccessMessage(message: "Recurring Item Added!")
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
    }
    
    private func addItem() {
        let newItem = BudgetItem(
            title: title,
            amount: amount,
            date: createDateWithDay(recurringDay),
            isInflux: isInflux,
            isRecurring: true,
            recurringDay: recurringDay
        )
        
        recurringItemsManager.addItem(newItem)
        
        withAnimation {
            showingSuccessMessage = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            dismiss()
        }
    }
    
    private func createDateWithDay(_ day: Int) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: Date())
        components.day = day
        return calendar.date(from: components) ?? Date()
    }
} 