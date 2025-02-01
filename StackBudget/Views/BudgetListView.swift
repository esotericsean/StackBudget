import SwiftUI

struct BudgetListView: View {
    @EnvironmentObject var budgetManager: BudgetManager
    @EnvironmentObject var recurringItemsManager: RecurringItemsManager
    @State private var showingAddBudget = false
    @State private var newBudgetTitle = ""
    @State private var showingNewBudgetSheet = false
    @State private var showingRecurringItemsSheet = false
    @State private var showingAboutSheet = false
    
    private var sortedBudgets: [Int] {
        budgetManager.budgets.indices.sorted { index1, index2 in
            budgetManager.budgets[index1].createdAt > budgetManager.budgets[index2].createdAt
        }
    }
    
    private func budgetBinding(for index: Int) -> Binding<StackBudget> {
        Binding(
            get: { budgetManager.budgets[index] },
            set: { newValue in
                budgetManager.budgets[index] = newValue
                budgetManager.updateBudget(newValue)
            }
        )
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    if sortedBudgets.isEmpty {
                        EmptyStateView(
                            title: "No Budgets Yet",
                            message: "Create your first budget by tapping the + button above",
                            systemImage: "plus.circle"
                        )
                    } else {
                        ForEach(sortedBudgets, id: \.self) { budgetId in
                            if let budget = budgetManager.budgets[safe: budgetId] {
                                NavigationLink {
                                    ContentView(budget: budgetBinding(for: budgetId))
                                } label: {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(budget.title)
                                            .font(AppTheme.headlineFont)
                                        
                                        HStack {
                                            Circle()
                                                .fill(budget.color)
                                                .frame(width: 12, height: 12)
                                            
                                            Text(budget.formattedDate)
                                                .font(AppTheme.subheadlineFont)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .padding(.vertical, 4)
                                }
                                .listRowBackground(AppTheme.cardBackground)
                                .swipeActions(edge: .leading, allowsFullSwipe: false) { }
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) { }
                            }
                        }
                    }
                }
                
                if budgetManager.isLoading {
                    LoadingView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.2))
                }
            }
            .navigationTitle("My Budgets")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingAboutSheet = true
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundColor(AppTheme.primaryColor)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingRecurringItemsSheet = true
                    } label: {
                        Image(systemName: "repeat.circle")
                            .foregroundColor(AppTheme.primaryColor)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        HapticManager.impact(style: .medium)
                        showingNewBudgetSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(AppTheme.primaryColor)
                    }
                }
            }
            .sheet(isPresented: $showingAboutSheet) {
                AboutView()
            }
            .animatedSheet(isPresented: $showingNewBudgetSheet) {
                NewBudgetView()
                    .environmentObject(budgetManager)
                    .environmentObject(recurringItemsManager)
            }
            .animatedSheet(isPresented: $showingRecurringItemsSheet) {
                RecurringItemsView()
                    .environmentObject(recurringItemsManager)
            }
            .scrollContentBackground(.hidden)
        }
    }
    
    private func deleteBudgets(at offsets: IndexSet) {
        HapticManager.notification(type: .warning)
        let sortedBudgets = budgetManager.budgets.sorted(by: { $0.createdAt > $1.createdAt })
        offsets.forEach { index in
            let budget = sortedBudgets[index]
            budgetManager.deleteBudget(budget)
        }
    }
}

struct BudgetListView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = BudgetManager()
        manager.addBudget("Sample Budget")
        
        return BudgetListView()
            .environmentObject(manager)
    }
}
