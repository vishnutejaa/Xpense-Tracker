//
//  AddTransactionView.swift
//  XpenseTracker
//
//  Created by Vishnu Tejaa on 3/17/24.
//

import SwiftUI

struct AddTransactionView: View {
    @ObservedObject var viewModel: TransactionViewModel
    @Binding var isPresented: Bool
    @State private var amount: String = ""
    @State private var category: String = ""
    @State private var date: Date = Date()
    @State private var isIncome: Bool = true
    @State private var payee: String = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                TextField("Category", text: $category)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                Toggle(isOn: $isIncome) {
                    Text("Is Income?")
                }
                TextField("Payee", text: $payee)
                
                Button("Save") {
                    if let amountValue = Double(amount) {
                        viewModel.transactions.append(Transaction(amount: amountValue, date: date, category: category, isIncome: isIncome, payee: payee))
                        isPresented = false
                    }
                }
            }
            .navigationBarTitle("Add Transaction")
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            })
        }
    }
}

