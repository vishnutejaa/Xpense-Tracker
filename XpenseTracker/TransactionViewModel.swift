//
//  TransactionViewModel.swift
//  TrackXpense
//
//  Created by Vishnu Tejaa on 3/17/24.
//

import Combine
import Foundation

class TransactionViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var budgets: [Budget] = []

    // Function to add a transaction
    func addTransaction(amount: Double, category: String, date: Date, isIncome: Bool, payee: String?) {
        let newTransaction = Transaction(amount: amount, date: date, category: category, isIncome: isIncome, payee: payee)
        transactions.append(newTransaction)
    }

    // Function to edit a transaction
    func editTransaction(id: UUID, amount: Double, category: String, date: Date, isIncome: Bool, payee: String?) {
        if let index = transactions.firstIndex(where: { $0.id == id }) {
            transactions[index].amount = amount
            transactions[index].category = category
            transactions[index].date = date
            transactions[index].isIncome = isIncome
            transactions[index].payee = payee
        }
    }

    // Function to delete a transaction
    func deleteTransaction(transactionID: UUID) {
        transactions.removeAll { $0.id == transactionID }
    }
    
    // Function to set a budget
    func setBudget(category: String, limit: Double) {
        if let index = budgets.firstIndex(where: { $0.category == category }) {
            budgets[index].limit = limit
        } else {
            let newBudget = Budget(category: category, limit: limit)
            budgets.append(newBudget)
        }
    }

    // Function to view report
    // This is a simple example that sums up the expenses and income
    func viewReport() -> (totalIncome: Double, totalExpenses: Double) {
        let totalIncome = transactions.filter { $0.isIncome }.reduce(0) { $0 + $1.amount }
        let totalExpenses = transactions.filter { !$0.isIncome }.reduce(0) { $0 + $1.amount }
        return (totalIncome, totalExpenses)
    }
    
    // More functionalities can be added as needed
}
