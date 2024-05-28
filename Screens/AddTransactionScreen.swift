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
    @State private var date : Date = Date()
    @State private var amount : String = ""
    @State private var category : TransactionCategory = .other
    @State private var showAlert = false
    @Query var accounts: [Account]
    @Query var transactions : [Transaction]
    @State var selectedAccount : Account? = nil
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Détails de la transaction")) {
                    TextField("Nom", text: $name)
                    TextField("Montant", text: $amount)
                    Picker("Compte :", selection: $selectedAccount) {
                        ForEach(accounts.filter {$0.isActive}) { account in
                            Text(account.name).tag(account as Account?)
                        }
                    }
                    DatePicker(
                        "Date",
                        selection: $date,
                        displayedComponents: [.date]
                    )
                    Picker ("Type :",selection: $category) {
                        ForEach (TransactionCategory.allCases, id: \.self) {category in
                            Text(category.rawValue)
                                .tag(category as TransactionCategory?)
                                .foregroundStyle(category.isGain() ? .green : .black)
                        }
                    }
                }
            }
            .navigationTitle("Nouvelle transaction")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        addTransaction()
                        
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Erreur"), message: Text("le montant saisie n'est pas un nombre valide"), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func addTransaction() {
        if let selectedAccount = selectedAccount {
            if let newAmount = stringToDouble(amount) {
                let amountAdjusted = category.isGain() ? newAmount : -newAmount
                let newTransaction = Transaction(name: name, amount: amountAdjusted, account: selectedAccount, date : date, category: category)
                modelContext.insert(newTransaction)
                dismiss()
            } else {
                showAlert.toggle()
            }
        } else {
            showAlert.toggle()
        }
    }
}
#Preview {
    AddTransactionScreen()
        .modelContainer(for: Transaction.self, inMemory: true)
}
