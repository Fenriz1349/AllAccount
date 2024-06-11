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
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]
    @Query(sort: \Account.name, order: .forward) private var accounts: [Account]
    @State private var showAddTransactionModal = false
    @State private var showAddAccountModal = false

    private var calendar: Calendar {
        Calendar.current
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.dateStyle = .full
        return formatter
    }

    private var years: [Int] {
        Array(Set(transactions.map { calendar.component(.year, from: $0.date) })).sorted(by: >)
    }

    private func months(in year: Int) -> [Int] {
        let transactionsInYear = transactions.filter { calendar.component(.year, from: $0.date) == year }
        return Array(Set(transactionsInYear.map { calendar.component(.month, from: $0.date) })).sorted(by: >)
    }

    private func days(in year: Int, month: Int) -> [Int] {
        let transactionsInMonth = transactions.filter {
            calendar.component(.year, from: $0.date) == year &&
            calendar.component(.month, from: $0.date) == month
        }
        return Array(Set(transactionsInMonth.map { calendar.component(.day, from: $0.date) })).sorted(by: >)
    }

    private func transactions(in year: Int, month: Int, day: Int) -> [Transaction] {
        transactions.filter {
            calendar.component(.year, from: $0.date) == year &&
            calendar.component(.month, from: $0.date) == month &&
            calendar.component(.day, from: $0.date) == day
        }
    }

    private func formattedDate(year: Int, month: Int, day: Int) -> String {
        let components = DateComponents(year: year, month: month, day: day)
        let date = calendar.date(from: components)!
        return dateFormatter.string(from: date)
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

                    ForEach(years, id: \.self) { year in
                        ForEach(months(in: year), id: \.self) { month in
                            ForEach(days(in: year, month: month), id: \.self) { day in
                                Section(header:
                                            HStack {
                                    Text("\(formattedDate(year: year, month: month, day: day))")
                                        .fontWeight(.bold)
                                        .padding(.leading, 35)
                                    Spacer()
                                }) {
                                    ForEach(transactions(in: year, month: month, day: day)) { transaction in
                                        TransactionRow(transaction: transaction)
                                    }
                                }
                                .padding(.bottom, 15)
                            }
                        }
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

