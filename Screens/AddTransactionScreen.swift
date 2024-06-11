//
//  AddTransactionScreen.swift
//  AllAccount
//
//  Created by Fen on 21/05/2024.
//

import SwiftUI
import SwiftData

struct AddTransactionScreen: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var name: String = ""
    @State private var date: Date = Date()
    @State private var amount: Double = 0.0
    @State private var category: TransactionCategory = .other
    @State private var showAlert = false
    @Query var accounts: [Account]
    @Query var transactions: [Transaction]
    @State var selectedAccount: Account? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Détails de la transaction")) {
                        TextField("Nom", text: $name)
                        HStack {
                            TextField("Montant", value: $amount, format: .number)
                                .foregroundStyle(category.isGain() ? .green : .black)
                            Text(category.isGain() ? "Entrée" : "Sortie")
                        }
                        Picker("Type :", selection: $category) {
                            ForEach(TransactionCategory.allCases.filter { $0 != .initialPositif && $0 != .initialNegatif }, id: \.self) { category in
                                Text(category.rawValue)
                                    .tag(category as TransactionCategory?)
                                    .foregroundStyle(category.isGain() ? .green : .black)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 50)
                        Picker("Compte :", selection: $selectedAccount) {
                            ForEach(accounts.filter { $0.isActive }) { account in
                                Text(account.name).tag(account as Account?)
                            }
                        }
                        .pickerStyle(.segmented)
                        DatePicker(
                            "Date :",
                            selection: $date,
                            displayedComponents: [.date]
                        )
                    }
                }
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Fermer")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                    Button(action: {
                        addTransaction()
                    }) {
                        Text("Valider")
                            .foregroundColor(.white)
                            .padding()
                            .background(.green)
                            .cornerRadius(8)
                    }
                    Spacer()
                }
                .padding(.bottom,275)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Erreur"), message: Text("Veuillez sélectionner un compte"), dismissButton: .default(Text("OK")))
                }
            }
            .navigationTitle("Nouvelle transaction")
        }
    }
    
    private func addTransaction() {
        if let selected = selectedAccount {
            let amountAdjusted = category.isGain() ? amount : -amount
            let newTransaction = Transaction(name: name, amount: amountAdjusted, account: selected, date: date, category: category)
            modelContext.insert(newTransaction)
            dismiss()
        }else {
            showAlert.toggle()
        }
    }
}

#Preview {
    AddTransactionScreen()
        .modelContainer(for: Transaction.self, inMemory: true)
}

