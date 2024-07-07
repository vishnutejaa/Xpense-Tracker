//
//  TransactionListview.swift
//  TrackXpense
//
//  Created by Vishnu Tejaa on 3/17/24.
//

import SwiftUI

struct TransactionListView: View {
    @StateObject var viewModel = TransactionViewModel()
    @State private var showingAddTransactionView = false

    var body: some View {
        NavigationView {
            List {
                ForEach($viewModel.transactions) { $transaction in
                    NavigationLink(destination: TransactionDetailView(transaction: $transaction)) {
                        TransactionRow(transaction: transaction)
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationBarTitle("Transactions")
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: {
                    showingAddTransactionView = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showingAddTransactionView) {
                // Assuming AddTransactionView is correctly implemented
                AddTransactionView(viewModel: viewModel, isPresented: $showingAddTransactionView)
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            viewModel.transactions.remove(at: index)
        }
    }
}



struct TransactionRow: View {
    var transaction: Transaction

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.category)
                    .font(.headline)
                Text(transaction.date, style: .date)
                    .font(.caption)
            }
            Spacer()
            Text(transaction.isIncome ? "Income" : "Expense")
                .foregroundColor(transaction.isIncome ? .green : .red)
            Spacer()
            Text("\(transaction.amount, specifier: "%.2f")")
                .foregroundColor(transaction.isIncome ? .green : .red)
        }
    }
}

struct TransactionDetailView: View {
    @Binding var transaction: Transaction
    @Environment(\.presentationMode) var presentationMode

    // Computed binding for handling optional `payee`
    private var payeeBinding: Binding<String> {
        Binding<String>(
            get: { transaction.payee ?? "" }, // Return an empty string if `payee` is nil
            set: { transaction.payee = $0.isEmpty ? nil : $0 } // Set `payee` to nil if the new value is an empty string, otherwise set to the new value
        )
    }

    var body: some View {
        Form {
            TextField("Amount", value: $transaction.amount, formatter: NumberFormatter())
            TextField("Category", text: $transaction.category)
            DatePicker("Date", selection: $transaction.date)
            Toggle("Is Income", isOn: $transaction.isIncome)
            TextField("Payee", text: payeeBinding) // Use the computed binding here
        }
        .navigationBarTitle("Edit Transaction", displayMode: .inline)
        .navigationBarItems(trailing: Button("Save") {
            // Implement saving logic here, if any
            self.presentationMode.wrappedValue.dismiss()
        })
    }
}


struct BudgetView: View {
    @ObservedObject var viewModel: TransactionViewModel
    @State private var category: String = ""
    @State private var limit: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Set a Budget")) {
                    TextField("Category", text: $category)
                    TextField("Limit", text: $limit)
                        .keyboardType(.decimalPad)
                    Button(action: setBudget) {
                        Text("Save Budget")
                    }
                }
            }
            .navigationBarTitle("Budgets")
        }
    }

    private func setBudget() {
        guard !category.isEmpty, let limitValue = Double(limit) else {
            // Handle the error, for example, show an alert
            return
        }
        viewModel.setBudget(category: category, limit: limitValue)
        // Reset the fields after saving the budget
        category = ""
        limit = ""
    }
}


struct ReportView: View {
    @ObservedObject var viewModel: TransactionViewModel

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Summary")) {
                    HStack {
                        Text("Total Income")
                        Spacer()
                        Text("\(viewModel.viewReport().totalIncome, specifier: "%.2f")")
                            .foregroundColor(.green)
                    }
                    HStack {
                        Text("Total Expenses")
                        Spacer()
                        Text("\(viewModel.viewReport().totalExpenses, specifier: "%.2f")")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("Report")
        }
    }
}




// Preview for SwiftUI canvas
struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView()
    }
}

