import SwiftUI

struct RecurringItemsView: View {
    @EnvironmentObject var recurringItemsManager: RecurringItemsManager
    @Environment(\.dismiss) var dismiss
    @State private var showingAddSheet = false
    
    private var sortedItems: [BudgetItem] {
        recurringItemsManager.recurringItems.sorted { item1, item2 in
            let day1 = item1.recurringDay ?? 1
            let day2 = item2.recurringDay ?? 1
            if day1 == day2 {
                return item1.title < item2.title
            }
            return day1 < day2
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                if sortedItems.isEmpty {
                    EmptyStateView(
                        title: "No Recurring Items",
                        message: "Add recurring items that will automatically be included in new budgets",
                        systemImage: "repeat.circle"
                    )
                } else {
                    ForEach(sortedItems) { item in
                        ZStack {
                            NavigationLink(destination: EditRecurringItemView(item: item)
                                .environmentObject(recurringItemsManager)) {
                                EmptyView()
                            }
                            .opacity(0)
                            
                            Button {
                                // This button will trigger the hidden NavigationLink
                            } label: {
                                VStack(alignment: .leading, spacing: AppTheme.smallSpacing) {
                                    Text(item.title)
                                        .font(AppTheme.headlineFont)
                                        .foregroundColor(.primary)
                                    HStack {
                                        Text(item.isInflux ? "Income" : "Expense")
                                            .foregroundColor(item.isInflux ? AppTheme.successColor : AppTheme.warningColor)
                                            .font(AppTheme.subheadlineFont)
                                        Text(item.formattedAmount)
                                            .foregroundColor(.primary)
                                            .font(AppTheme.bodyFont)
                                        Spacer()
                                        HStack(spacing: 4) {
                                            Image(systemName: "calendar")
                                                .font(AppTheme.subheadlineFont)
                                            Text("Day \(item.recurringDay ?? 1)")
                                                .font(AppTheme.subheadlineFont)
                                        }
                                        .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.vertical, AppTheme.smallSpacing)
                            }
                        }
                        .listRowBackground(AppTheme.cardBackground)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                recurringItemsManager.removeItem(item)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Recurring Items")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.primaryColor)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(AppTheme.primaryColor)
                    }
                }
            }
            .animatedSheet(isPresented: $showingAddSheet) {
                AddRecurringItemView()
                    .environmentObject(recurringItemsManager)
            }
        }
        .listStyle(.plain)
    }
} 