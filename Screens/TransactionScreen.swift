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
    @Query (sort: \Transaction.amount, order: .forward)private var transactions: [Transaction]
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
                } else if !transactions.filter({!$0.isActive}).isEmpty && transactions.filter({$0.isActive}).isEmpty{
                    VStack {
                        Text("Vous n'avez pas encore de transaction active")
                            .font(.title)
                            .padding()
                        ExtButtonAdd(text : "Ajouter",showModale: $showAddTransactionModal)
                            .sheet(isPresented: $showAddTransactionModal, content: {
                                AddTransactionScreen()
                            })
                    }
                }else {
                    List {
                        ForEach(transactions.filter { $0.isActive }) { transaction in
                            NavigationLink {
                                TransactionDetailScreen()
                            }label : {
                                VStack(alignment: .leading) {
                                    Text(transaction.name)
                                        .font(.headline)
                                        .foregroundStyle(transaction.isActive ? .green : .red)
                                    Text(transaction.account.name)
                                    Text("montant: \(transaction.amount, specifier: "%.2f")")
                                        .foregroundColor(.blue)
                                }
                            }
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

