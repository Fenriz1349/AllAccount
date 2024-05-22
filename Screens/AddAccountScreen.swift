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
    @State private var name: String = ""
    @State private var showAlert = false
    @Query var accounts: [Account]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Détails du compte")) {
                    TextField("Nom", text: $name)
                }
            }
            .navigationTitle("Nouveau Compte")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
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
        let newAccount = Account(name: name)
        modelContext.insert(newAccount)
    }
}

#Preview {
    AddAccountScreen()
        .modelContainer(for: Account.self, inMemory: true)
}


