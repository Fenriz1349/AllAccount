//
//  AccountDetail.swift
//  AllAccount
//
//  Created by Fen on 21/05/2024.
//

import SwiftUI
import SwiftData

struct AccountDetail: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    var account: Account
    @State private var accountCopy: AccountCopy
    @State private var showRenameAlert = false
    @State private var newName: String = ""

    struct AccountCopy {
        var name: String
        var isActive: Bool
        var transactions : [Transaction]?
        func totalTransactionsAmount() -> Double {
            guard let transactions = transactions else {
                return 0.0
            }
            return transactions.filter { $0.isActive }.reduce(0.0) { $0 + $1.amount }
        }
    }

        init(account: Account) {
            self.account = account
            _accountCopy = State(initialValue: AccountCopy(name: account.name, isActive: account.isActive, transactions: nil))
        }
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(accountCopy.name)
                    .font(.headline)
                    .foregroundStyle(accountCopy.isActive ? .green : .red)
                Text("Statut : \(accountCopy.isActive ? "actif" : "inactif")")
            }
            .padding(.bottom)
            
            Text("Total: \(accountCopy.totalTransactionsAmount(), specifier: "%.2f")")
                .foregroundColor(.blue)
            HStack{
                Button(action: {
                    accountCopy.isActive.toggle()
                }) {
                    Text(account.isActive ? "Désactiver" : "Activer")
                        .foregroundColor(.white)
                        .padding()
                        .background(account.isActive ? Color.red : Color.green)
                        .cornerRadius(8)
                }
                .padding(.bottom)
                
                Button(action: {
                    newName = accountCopy.name
                    showRenameAlert = true
                }) {
                    Text("Modifier le nom")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            HStack {
                Button(action: {
                    account.name = accountCopy.name
                    account.isActive = accountCopy.isActive
                    do {
                        try modelContext.save()
                        dismiss()
                    } catch {
                        print("Erreur lors de la sauvegarde : \(error)")
                    }
                }) {
                    Text("Valider")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8)
                }
                .padding(.bottom)
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Annuler")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                }
                .padding(.bottom)
            }
        }
        .padding()
        .alert("Modifier le nom", isPresented: $showRenameAlert, actions: {
            TextField("Nouveau nom", text: $newName)
            Button("Annuler", role: .cancel) {}
            Button("Enregistrer") {
                if !newName.isEmpty {
                    accountCopy.name = newName
                }
            }
        }, message: {
            Text("Veuillez saisir un nouveau nom pour le compte.")
        })
    }
}

#Preview {
    AccountDetail(account: Account(name: "Compte de test", isActive: true, user: User(name: "testeur", birthDate: Date())))
        .modelContainer(for: Account.self, inMemory: true)
}


