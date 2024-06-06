//
//  TransactionScreen.swift
//  AllAccount
//
//  Created by Fen on 21/05/2024.
//

import SwiftUI
import SwiftData

struct TransactionsScreen: View {
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
                ScrollView {
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
                        ExtButtonAdd(text: "Ajouter", showModale: $showAddTransactionModal)
                            .sheet(isPresented: $showAddTransactionModal) {
                                AddTransactionScreen()
                            }
                        ForEach(sortedDates, id: \.self) { date in
                            Section(header:
                                        HStack {
                                Text("\(DateToStringDayMonth(date))")
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .padding(.leading,35)
                                Spacer()
                            }) {
                                ForEach(transactionsByDay[date] ?? []) { transaction in
                                    TransactionRow(transaction: transaction)
                                }
                            }
                            .padding(.bottom,15)
                        }
                    }
                }
                .navigationTitle("Transactions")
            }
        }
}
#Preview {
    let modelContainer = DataController.previewContainer
    return TransactionsScreen()
        .environment(\.modelContext, modelContainer.mainContext)
}

