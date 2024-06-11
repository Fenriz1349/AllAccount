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
    @State private var initialSold : Double = 0.0
    @State private var isPositif : Bool = true
    @State private var creationDate : Date = Date()
    @Query var accounts: [Account]
    @Query var users : [User]

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Détails du compte")) {
                        TextField("Nom", text: $name)
                        Picker ("Type :",selection: $accountType) {
                            ForEach (AccountCategory.allCases, id: \.self) {accountType in
                                Text(accountType.rawValue).tag(accountType as AccountCategory?)
                            }
                        }.pickerStyle(.segmented)
                        HStack {
                            Text("Solde Initial")
                            TextField ("Solde Initial",value: $initialSold, format: .number)
                        }
                        Toggle(isOn: $isPositif, label: {
                            Text(isPositif ? "Positif" : "Négatif")
                        })
                        DatePicker(
                            "Date",
                            selection: $creationDate,
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
                        addAccount()
                    }) {
                        Text("Valider")
                            .foregroundColor(.white)
                            .padding()
                            .background(.green)
                            .cornerRadius(8)
                    }
                    Spacer()
                }
                .padding(.bottom,300)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Erreur"), message: Text("Le nom existe déjà."), dismissButton: .default(Text("OK")))
                }
            }
            .navigationTitle("Nouveau Compte")
        }
    }
    private func addAccount() {
        let newAccount = Account(name: name, user: currentUser, accountCategory: accountType)
        modelContext.insert(newAccount)
        if let lastAccount = accounts.first {
            let initialTransaction = Transaction(name: "Solde Initial", amount: isPositif ? initialSold : -initialSold, account: lastAccount, date: creationDate, category: isPositif ? .initialPositif : .initialNegatif)
            lastAccount.addTransaction(initialTransaction)
            modelContext.insert(initialTransaction)
        }
        dismiss()
    }
}

#Preview {
    AddAccountScreen()
        .environment(\.modelContext, DataController.previewContainer.mainContext)
        .environmentObject(DataController())
}


