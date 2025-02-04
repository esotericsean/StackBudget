import SwiftUI

struct ContentView: View {
    @EnvironmentObject var budgetManager: BudgetManager
    @Binding var budget: StackBudget
    @State private var showingAddSheet = false
    @State private var showingEditSheet = false
    @Environment(\.dismiss) private var dismiss
    
    private var sortedItems: [BudgetItem] {
        budget.items.sorted { $0.date < $1.date }
    }
    
    private var remainingBalance: Double {
        let balance = budget.items.first(where: { $0.isCurrentBalance })?.amount ?? 0
        let impact = budget.items
            .filter { !$0.isCurrentBalance }
            .reduce(0) { $0 + $1.impact }
        return balance + impact
    }
    
    private func calculateRunningBalance(upTo item: BudgetItem) -> Double {
        var balance = budget.items.first(where: { $0.isCurrentBalance })?.amount ?? 0
        for budgetItem in sortedItems where !budgetItem.isCurrentBalance && budgetItem.date <= item.date {
            balance += budgetItem.impact
        }
        return balance
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
    
    var body: some View {
        List {
            // Current Balance Section
            Section {
                if let firstIndex = budget.items.firstIndex(where: { $0.isCurrentBalance }) {
                    CurrentBalanceRow(
                        amount: Binding(
                            get: { budget.items[firstIndex].amount },
                            set: { newValue in
                                var updatedBudget = budget
                                updatedBudget.items[firstIndex].amount = newValue
                                budget = updatedBudget
                                budgetManager.updateBudget(updatedBudget)
                            }
                        ),
                        budget: $budget
                    )
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .listRowBackground(AppTheme.cardBackground)
            
            // Expenses Section
            Section {
                ForEach(Array(sortedItems.enumerated()), id: \.element.id) { index, item in
                    if !item.isCurrentBalance {
                        BudgetItemRow(
                            item: item,
                            remainingBalance: calculateRunningBalance(upTo: item),
                            baseColor: budget.color,
                            isEven: index % 2 == 0,
                            budget: $budget
                        )
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .scale.combined(with: .opacity)
                        ))
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                withAnimation {
                                    if let index = budget.items.firstIndex(where: { $0.id == item.id }) {
                                        var updatedBudget = budget
                                        updatedBudget.items.remove(at: index)
                                        budget = updatedBudget
                                        budgetManager.updateBudget(updatedBudget)
                                        HapticManager.notification(type: .success)
                                    }
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            
            // Final Balance Section
            Section {
                HStack {
                    Text("Final Balance")
                        .font(AppTheme.headlineFont)
                    Spacer()
                    AnimatedNumber(value: remainingBalance) { amount in
                        formatCurrency(amount)
                    }
                    .foregroundColor(remainingBalance >= 0 ? AppTheme.successColor : AppTheme.warningColor)
                    .font(AppTheme.headlineFont)
                }
            }
            .listRowBackground(AppTheme.cardBackground)
        }
        .navigationTitle(budget.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: AppTheme.spacing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(AppTheme.primaryColor)
                    }
                    
                    Button {
                        showingEditSheet = true
                    } label: {
                        Image(systemName: "pencil")
                            .foregroundColor(AppTheme.primaryColor)
                    }
                }
            }
        }
        .animatedSheet(isPresented: $showingAddSheet) {
            AddBudgetItemView(budget: $budget)
                .environmentObject(budgetManager)
        }
        .animatedSheet(isPresented: $showingEditSheet) {
            EditBudgetView(budget: $budget)
                .environmentObject(budgetManager)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: sortedItems)
    }
    
    private func deleteItems(at offsets: IndexSet) {
        HapticManager.notification(type: .warning)
        withAnimation {
            var updatedBudget = budget
            let nonCurrentBalanceItems = updatedBudget.items.filter { !$0.isCurrentBalance }
            offsets.forEach { index in
                if let itemToDelete = nonCurrentBalanceItems[safe: index],
                   let actualIndex = updatedBudget.items.firstIndex(where: { $0.id == itemToDelete.id }) {
                    updatedBudget.items.remove(at: actualIndex)
                }
            }
            budget = updatedBudget
            budgetManager.updateBudget(updatedBudget)
        }
    }
}

struct CurrentBalanceRow: View {
    @Binding var amount: Double
    @State private var showingEditSheet = false
    @EnvironmentObject var budgetManager: BudgetManager
    @Binding var budget: StackBudget
    
    var body: some View {
        Button {
            showingEditSheet = true
        } label: {
            HStack {
                Text("Current Balance")
                    .font(AppTheme.headlineFont)
                    .foregroundColor(.primary)
                Spacer()
                AnimatedNumber(value: amount) { amount in
                    formatCurrency(amount)
                }
                .font(AppTheme.headlineFont)
                .foregroundColor(.primary)
            }
            .contentShape(Rectangle())
            .padding(.vertical, AppTheme.smallSpacing)
        }
        .buttonStyle(.plain)
        .animatedSheet(isPresented: $showingEditSheet) {
            EditBalanceView(budget: $budget, currentAmount: amount)
                .environmentObject(budgetManager)
        }
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}

struct BudgetItemRow: View {
    let item: BudgetItem
    let remainingBalance: Double
    let baseColor: Color
    let isEven: Bool
    @Binding var budget: StackBudget
    @State private var showingEditSheet = false
    @EnvironmentObject var budgetManager: BudgetManager
    
    var body: some View {
        Button {
            HapticManager.impact(style: .light)
            showingEditSheet = true
        } label: {
            VStack(alignment: .leading, spacing: AppTheme.smallSpacing) {
                HStack {
                    Text(item.title)
                        .font(AppTheme.headlineFont)
                        .foregroundColor(.primary)
                    Spacer()
                    Text(item.isInflux ? "+\(item.formattedAmount)" : "-\(item.formattedAmount)")
                        .foregroundColor(item.isInflux ? AppTheme.successColor : AppTheme.warningColor)
                        .font(AppTheme.bodyFont)
                }
                
                HStack {
                    Text(item.formattedDate)
                        .font(AppTheme.subheadlineFont)
                        .foregroundColor(.secondary)
                    Spacer()
                    AnimatedNumber(value: remainingBalance) { amount in
                        "Balance: \(formatCurrency(amount))"
                    }
                    .font(AppTheme.subheadlineFont)
                    .foregroundColor(remainingBalance >= 0 ? AppTheme.successColor : AppTheme.warningColor)
                }
            }
            .padding(.vertical, AppTheme.smallSpacing)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .listRowBackground(Color.alternatingColors(for: baseColor, isEven: isEven))
        .sheet(isPresented: $showingEditSheet) {
            EditBudgetItemView(budget: $budget, item: item)
                .environmentObject(budgetManager)
        }
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleBudget = StackBudget(
            title: "Preview Budget",
            items: [
                BudgetItem(title: "Current Balance", amount: 1000, date: Date(), isCurrentBalance: true),
                BudgetItem(title: "Groceries", amount: 50, date: Date(), isInflux: false),
                BudgetItem(title: "Paycheck", amount: 1000, date: Date(), isInflux: true)
            ]
        )
        
        return NavigationStack {
            ContentView(budget: .constant(sampleBudget))
                .environmentObject(BudgetManager())
        }
    }
}
