//
//  AddAccountScreen.swift
//  AllAccount
//
//  Created by Fen on 21/05/2024.
//

import SwiftUI
import SwiftData

struct AddAccountScreen: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var dataController: DataController

    private var currentUser: User {
        dataController.currentUser
    }

    
    @State private var name: String = ""
    @State private var accountType : AccountCategory = .bank
    @State private var showAlert = false
    @State private var initialSold : String = ""
    @State private var isPositif : Bool = true
    @State private var creationDate : Date = Date()
    @Query var accounts: [Account]
    @Query var users : [User]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Détails du compte")) {
                    TextField("Nom", text: $name)
                    Picker ("Type :",selection: $accountType) {
                        ForEach (AccountCategory.allCases, id: \.self) {accountType in
                            Text(accountType.rawValue).tag(accountType as AccountCategory?)
                        }
                    }.pickerStyle(.segmented)
                    HStack {
                        TextField ("Solde Initial",text: $initialSold)
                        Toggle(isOn: $isPositif, label: {
                            Text(isPositif ? "Positif" : "Négatif")
                        })
                    }
                   
                    DatePicker(
                        "Date",
                        selection: $creationDate,
                        displayedComponents: [.date]
                    )
                }
            }
            .navigationTitle("Nouveau Compte")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Fermer") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Sauvegarder") {
                        if accounts.contains(where: { $0.name == name }) {
                            showAlert = true
                        } else {
                            addAccount()
                            dismiss()
                        }
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Erreur"), message: Text("Le nom existe déjà."), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func addAccount() {
            let newAccount = Account(name: name, user: currentUser, accountCategory: accountType)
            modelContext.insert(newAccount)
        if let initial = stringToDouble(initialSold) {
            let initialTransaction = Transaction(name: "Solde Initial", amount: isPositif ? initial : -initial, account: newAccount, date: creationDate, category: .salary)
                modelContext.insert(initialTransaction)
            }
    }
}

#Preview {
    AddAccountScreen()
        .modelContainer(for: Account.self, inMemory: true)
        .modelContainer(for: User.self, inMemory: true)
}


