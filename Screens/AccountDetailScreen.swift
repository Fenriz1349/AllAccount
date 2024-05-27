//
//  AccountDetail.swift
//  AllAccount
//
//  Created by Fen on 21/05/2024.
//

import SwiftUI
import SwiftData

struct AccountDetailScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    var account: Account

    @State private var newName: String
    @State private var newIsActive: Bool
    @State private var showValidateAlert = false
    @State private var isEditing = false

    init(account: Account) {
        self.account = account
        _newName = State(initialValue: account.name)
        _newIsActive = State(initialValue: account.isActive)
    }

    var body: some View {
        VStack(alignment: .leading) {
            if isEditing {
                TextField("Nouveau nom", text: $newName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Toggle("Statut", isOn: $newIsActive)
                    .padding()
            } else {
                HStack {
                    Text(account.name)
                        .font(.headline)
                        .foregroundStyle(account.isActive ? .green : .red)
                    Text("Statut : \(account.isActive ? "actif" : "inactif")")
                }
            }
            
            Text("Total: \(account.totalTransactionsAmount(), specifier: "%.2f")")
                .foregroundColor(.blue)
            ForEach(account.transactions) { transaction in
                TransactionAccountRow(transaction: transaction)
            }
            HStack {
                if !isEditing {
                    Button(action: {
                        newIsActive = account.isActive
                        isEditing.toggle()
                    }) {
                        Text(account.isActive ? "Désactiver" : "Activer")
                            .foregroundColor(.white)
                            .padding()
                            .background(account.isActive ? Color.red : Color.green)
                            .cornerRadius(8)
                    }
                    .padding(.bottom)
                }
                
                Button(action: {
                    if isEditing {
                        showValidateAlert.toggle()
                    } else {
                        newName = account.name
                        newIsActive = account.isActive
                        isEditing.toggle()
                    }
                }) {
                    Text(isEditing ? "Valider" : "Modifier")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.bottom)

                if isEditing {
                    Button(action: {
                        isEditing.toggle()
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
        }
        .padding()
        .alert("Valider les modifications", isPresented: $showValidateAlert, actions: {
            Button("Annuler", role: .cancel) {}
            Button("Valider", role: .none) {
                account.name = newName
                account.isActive = newIsActive
                do {
                    try modelContext.save()
                    dismiss()
                } catch {
                    print("Erreur lors de la sauvegarde : \(error)")
                }
            }
        }, message: {
            Text("Êtes-vous sûr de vouloir valider les modifications ?")
        })
    }
}

#Preview {
    let modelContainer = DataController.previewContainer
    let firstAccount = try! modelContainer.mainContext.fetch(FetchDescriptor<Account>()).first!
    return AccountDetailScreen(account: firstAccount)
        .environment(\.modelContext, modelContainer.mainContext)
        .environmentObject(DataController())
}
