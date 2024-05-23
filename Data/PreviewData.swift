//
//  Data.swift
//  AllAccount
//
//  Created by Fen on 23/05/2024.
//

import Foundation
import SwiftData


import SwiftUI
import SwiftData

@MainActor
class DataController: ObservableObject {
    let container: ModelContainer
    @Published var isInitialized: Bool = false

    init(inMemory: Bool = false) {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: inMemory)
            self.container = try ModelContainer(for: User.self, Account.self, Transaction.self, configurations: config)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    func initializeSampleData() {
        let context = container.mainContext
        do {
            let users: [User] = try context.fetch(FetchDescriptor<User>())
            if users.isEmpty {
                let sampleUser = User(name: "Sample User", birthDate: Date(), mail: "user@example.com", password: "password")
                context.insert(sampleUser)

                let sampleAccount1 = Account(name: "Sample Account 1", user: sampleUser)
                context.insert(sampleAccount1)

                let sampleAccount2 = Account(name: "Sample Account 2", user: sampleUser)
                context.insert(sampleAccount2)

                let sampleTransactions1 = [
                    Transaction(name: "Sample Test 1", amount: 10.0, account: sampleAccount1),
                    Transaction(name: "Sample Test 2", amount: 20.0, account: sampleAccount1),
                    Transaction(name: "Sample Test 3", amount: 30.0, account: sampleAccount1)
                ]

                let sampleTransactions2 = [
                    Transaction(name: "Sample Test 4", amount: 40.0, account: sampleAccount2),
                    Transaction(name: "Sample Test 5", amount: 50.0, account: sampleAccount2)
                ]

                for transaction in sampleTransactions1 {
                    context.insert(transaction)
                }

                for transaction in sampleTransactions2 {
                    context.insert(transaction)
                }

                try context.save()
                isInitialized = true
                print("Données d'exemple créées avec succès.")
            } else {
                isInitialized = true
                print("Des utilisateurs existent déjà, aucune donnée d'exemple n'a été créée.")
            }
        } catch {
            print("Erreur lors de la création des données d'exemple : \(error)")
        }
    }

    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: User.self, Account.self, Transaction.self, configurations: config)

            // Créer un utilisateur d'exemple
            let previewUser = User(name: "Preview User 1", birthDate: Date(), mail: "user@example.com", password: "password")
            container.mainContext.insert(previewUser)

            // Créer des comptes d'exemple pour cet utilisateur
            let previewAccount1 = Account(name: "Preview Account 1", user: previewUser)
            container.mainContext.insert(previewAccount1)

            let previewAccount2 = Account(name: "Preview Account 2", user: previewUser)
            container.mainContext.insert(previewAccount2)

            // Créer des transactions d'exemple pour le premier compte
            let previewTransactions1 = [
                Transaction(name: "Preview Test 1", amount: 10.0, account: previewAccount1),
                Transaction(name: "Preview Test 2", amount: 20.0, account: previewAccount1),
                Transaction(name: "Preview Test 3", amount: 30.0, account: previewAccount1)
            ]

            // Créer des transactions d'exemple pour le deuxième compte
            let previewTransactions2 = [
                Transaction(name: "Preview Test 4", amount: 40.0, account: previewAccount2),
                Transaction(name: "Preview Test 5", amount: 50.0, account: previewAccount2)
            ]

            for transaction in previewTransactions1 {
                container.mainContext.insert(transaction)
            }

            for transaction in previewTransactions2 {
                container.mainContext.insert(transaction)
            }

            try container.mainContext.save()

            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
}


