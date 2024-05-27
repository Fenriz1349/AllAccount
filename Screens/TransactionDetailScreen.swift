//
//  TransactionDetailScreen.swift
//  AllAccount
//
//  Created by Fen on 22/05/2024.
//

import SwiftUI
import SwiftData

struct TransactionDetailScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query var accounts: [Account]
    var transaction: Transaction

    @State private var newName: String = ""
    @State private var newAmount: Double = 0.0
    @State private var newDate: Date = Date()
    @State private var newAccount: Account?
    @State private var showEraseAlert = false
    @State private var showValidateAlert = false
    @State private var isEditing = false

    init(transaction: Transaction) {
        self.transaction = transaction
        _newName = State(initialValue: transaction.name)
        _newAmount = State(initialValue: transaction.amount)
        _newDate = State(initialValue: transaction.date)
        _newAccount = State(initialValue: transaction.account)
    }
    var body: some View {
        VStack(alignment: .leading) {
            if isEditing {
                TextField("Nouveau nom", text: $newName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Picker("Nouveau compte", selection: $newAccount) {
                    ForEach(accounts.filter { $0.isActive }, id: \.self) { account in
                        Text(account.name).tag(account as Account?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                DatePicker("Nouvelle date", selection: $newDate, displayedComponents: .date)
                TextField("Nouveau montant", value: $newAmount, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                Text(transaction.name)
                    .font(.headline)
                Text(transaction.account.name)
                HStack {
                    Text("le \(DateToStringDayMonth(transaction.date))")
                    Text("montant:")
                    ExtEuroAmmount(amount: transaction.amount)
                }
            }

            HStack {
                Button(action: {
                    showEraseAlert.toggle()
                }) {
                    Text("Supprimer")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                }
                .padding(.bottom)

                Button(action: {
                    if isEditing {
                        showValidateAlert.toggle()
                    } else {
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
        .alert("Confirmer la suppression", isPresented: $showEraseAlert, actions: {
            Button("Annuler", role: .cancel) {}
            Button("Supprimer", role: .destructive) {
                modelContext.delete(transaction)
                do {
                    try modelContext.save()
                    dismiss()
                } catch {
                    print("Erreur lors de la suppression : \(error)")
                }
            }
        }, message: {
            Text("Êtes-vous sûr de vouloir supprimer cette transaction ?")
        })
        .alert("Valider les modifications", isPresented: $showValidateAlert, actions: {
            Button("Annuler", role: .cancel) {}
            Button("Valider", role: .none) {
                transaction.name = newName
                transaction.amount = newAmount
                transaction.date = newDate
                if let account = newAccount {
                    transaction.account = account
                }
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
    let firstTransaction = try! modelContainer.mainContext.fetch(FetchDescriptor<Transaction>()).first!
    return TransactionDetailScreen(transaction: firstTransaction)
        .environment(\.modelContext, modelContainer.mainContext)
        .environmentObject(DataController())
}

