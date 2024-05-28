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
    @Query(sort: \Transaction.date, order: .forward) private var transactions: [Transaction]
    @Query(sort: \Account.name, order: .forward) private var accounts: [Account]
    @State private var showAddTransactionModal = false
    @State private var showAddAccountModal = false

    private var transactionsByDay: [Date: [Transaction]] {
           let calendar = Calendar.current
           return Dictionary(grouping: transactions) { transaction in
               calendar.startOfDay(for: transaction.date)
           }
       }

    private var sortedDates: [Date] {
        transactionsByDay.keys.sorted().reversed()
    }

    var body: some View {
        NavigationView {
            VStack {
                if accounts.isEmpty {
                    VStack {
                        Text("Vous n'avez pas encore de Compte")
                            .font(.title)
                            .padding()
                        ExtButtonAdd(text: "Créer", showModale: $showAddAccountModal)
                            .sheet(isPresented: $showAddAccountModal) {
                                AddAccountScreen()
                            }
                    }
                } else if transactions.isEmpty {
                    VStack {
                        Text("Vous n'avez pas encore de transaction")
                            .font(.title)
                            .padding()
                        ExtButtonAdd(text: "Ajouter", showModale: $showAddTransactionModal)
                            .sheet(isPresented: $showAddTransactionModal) {
                                AddTransactionScreen()
                            }
                    }
                } else {
                    List {
                        ForEach(sortedDates, id: \.self) { date in
                            Section(header: ExtBlueRibbon(text:"\(DateToStringDayMonth(date))")) {
                                ForEach(transactionsByDay[date] ?? []) { transaction in
                                    TransactionRow(transaction: transaction)
                                }
                            }
                        }
                    }
                    ExtButtonAdd(text: "Ajouter", showModale: $showAddTransactionModal)
                        .sheet(isPresented: $showAddTransactionModal) {
                            AddTransactionScreen()
                        }
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
