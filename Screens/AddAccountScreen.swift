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
    @State private var alertMessage = ""
    @State private var messageAlert : String = ""
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
                    Alert(title: Text("Erreur"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .navigationTitle("Nouveau Compte")
        }
    }
    private func addAccount() {
            guard name != "" else {
                alertMessage = "Veuillez entrer un nom de compte"
                showAlert = true
                return
            }
            
        guard accounts.filter({ ($0.name).lowercased() == name.lowercased() }).isEmpty else {
                alertMessage = "Le nom du compte existe déjà"
                showAlert = true
                return
            }
            
            let newAccount = Account(name: name, user: currentUser, accountCategory: accountType, dateCreated: creationDate)
            modelContext.insert(newAccount)
            
            let initialTransaction = Transaction(name: "Solde Initial", amount: isPositif ? initialSold : -initialSold, account: newAccount, date: creationDate, category: isPositif ? .initialPositif : .initialNegatif)
            newAccount.addTransaction(initialTransaction)
            modelContext.insert(initialTransaction)
            
            dismiss()
        }
}

#Preview {
    AddAccountScreen()
        .environment(\.modelContext, DataController.previewContainer.mainContext)
        .environmentObject(DataController())
}


