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
    @Query (sort: \Transaction.date, order: .forward)private var transactions: [Transaction]
    @Query (sort: \Account.name, order: .forward) private var accounts: [Account]
    @State private var selectedAccount: Account?
    @State private var showAddTransactionModal = false
    @State private var showAddAccountModal = false
    
    var body: some View {
        NavigationView {
            VStack {
                if accounts.isEmpty {
                    VStack {
                        Text("Vous n'avez pas encore de Compte")
                            .font(.title)
                            .padding()
                        ExtButtonAdd(text : "Créer",showModale: $showAddAccountModal)
                        .sheet(isPresented: $showAddAccountModal, content: {
                            AddAccountScreen()
                        })
                    }
                }else if transactions.isEmpty {
                    VStack {
                        Text("Vous n'avez pas encore de transaction")
                            .font(.title)
                            .padding()
                        ExtButtonAdd(text : "Ajouter",showModale: $showAddTransactionModal)
                            .sheet(isPresented: $showAddTransactionModal, content: {
                                AddTransactionScreen()
                            })
                    }
                }else {
                    List {
                        ForEach(transactions) { transaction in
                            TransactionRow(transaction: transaction)
                        }
                    }
                    ExtButtonAdd(text : "Ajouter",showModale: $showAddTransactionModal)
                        .sheet(isPresented: $showAddTransactionModal, content: {
                            AddTransactionScreen()
                        })
                }
            }
            .navigationTitle("Transactions")
        }
    }
}

#Preview {
    TransactionScreen()
        .modelContainer(for: Account.self, inMemory: true)
        .modelContainer(for: Transaction.self, inMemory: true)
}

