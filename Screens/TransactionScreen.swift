//
//  TransactionScreen.swift
//  AllAccount
//
//  Created by Fen on 21/05/2024.
//

import SwiftUI
import SwiftData

struct TransactionScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var transactions: [Transaction]
    @Query private var accounts: [Account]
    @State private var selectedAccount: Account?
    @State private var index: Int = 1
    @State private var showAddAccountModal = false

    var body: some View {
        NavigationView {
            VStack {
                Picker("Select Account", selection: $selectedAccount) {
                    ForEach(accounts) { account in
                        Text(account.name).tag(account as Account?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()

                List {
                    ForEach(transactions) { transaction in
                        VStack(alignment: .leading) {
                            Text(transaction.name)
                                .font(.headline)
                            Text("Amount: \(transaction.amount, specifier: "%.2f")")
                                .foregroundColor(transaction.isActive ? .green : .red)
                            Text("Account: \(transaction.accountName)")
                        }
                        .contextMenu {
                            Button(action: {
                                toggleTransactionStatus(transaction)
                            }) {
                                Text(transaction.isActive ? "Deactivate" : "Activate")
                                Image(systemName: transaction.isActive ? "xmark.circle" : "checkmark.circle")
                            }
                        }
                    }
                    .onDelete(perform: deleteTransactions)
                }
                .navigationTitle("Transactions")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: addTransaction) {
                            Label("Add Transaction", systemImage: "plus")
                        }
                    }
                }
            }
        }
    }

    private func addTransaction() {
        guard let selectedAccount = selectedAccount else {
            print("No account selected")
            return
        }
        withAnimation {
            let newTransaction = Transaction(name: "Transaction \(index)", amount: Double.random(in: 1...100), account: selectedAccount)
            modelContext.insert(newTransaction)
            index += 1
        }
    }

    private func toggleTransactionStatus(_ transaction: Transaction) {
        withAnimation {
            transaction.isActive.toggle()
        }
    }

    private func deleteTransactions(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(transactions[index])
            }
        }
    }
}

#Preview {
    TransactionScreen()
        .modelContainer(for: Account.self, inMemory: true)
        .modelContainer(for: Transaction.self, inMemory: true)
}

