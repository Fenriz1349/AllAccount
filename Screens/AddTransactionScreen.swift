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
    @State private var amount: Double? = nil
    @State private var category: TransactionCategory = .other
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var selectedAccount: Account? = nil
    @Query var accounts: [Account]
    @Query var transactions: [Transaction]
    
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
                        .frame(height: 100)
                        Picker("Compte :", selection: $selectedAccount) {
                            ForEach(accounts.filter { $0.isActive }) { account in
                                Text(account.name).tag(account as Account?)
                            }
                        }
                        .pickerStyle(.segmented)
                        .onAppear {
                            if selectedAccount == nil, let firstAccount = accounts.first {
                                selectedAccount = firstAccount
                            }
                        }
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
                .padding(.bottom, 250)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Erreur"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .navigationTitle("Nouvelle transaction")
        }
    }
    
    private func addTransaction() {
        guard let amount = amount, amount != 0.0 else {
            alertMessage = "Veuillez entrer un montant valide et différent de zéro"
            showAlert = true
            return
        }
        guard let selected = selectedAccount else {
            alertMessage = "Veuillez sélectionner un compte"
            showAlert = true
            return
        }
        let amountAdjusted = category.isGain() ? amount : -amount
        let newTransaction = Transaction(name: name, amount: amountAdjusted, account: selected, date: date, category: category)
        modelContext.insert(newTransaction)
        dismiss()
    }
}

#Preview {
    AddTransactionScreen()
        .environment(\.modelContext, DataController.previewContainer.mainContext)
        .environmentObject(DataController())
}

