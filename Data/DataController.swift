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
    @Published var currentUser: User
    @Published var isInitialized: Bool = false
// initialisation du ModelContainer, et création d'un utilisateur par default
    init(inMemory: Bool = false) {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: inMemory)
            self.container = try ModelContainer(for: User.self, Account.self, Transaction.self, configurations: config)
            self.currentUser = User(name: "Guest", birthDate: Date()) // Valeur par défaut pour currentUser
            initializeSampleData()
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

//  fonction pour récuperer le premier utilisateur de la BDD ou l'utilisateur guest par defaut
    func fetchCurrentUser() -> User {
        let context = container.mainContext
        do {
            let users: [User] = try context.fetch(FetchDescriptor<User>())
            if let firstUser = users.first {
                return firstUser
            }
        } catch {
            print("Failed to fetch current user: \(error)")
        }
        return User(name: "Guest", birthDate: Date())
    }

//    fonction pour créer un nouvel utilisateur, il n'est pas defini comme le currentUser
    func createNewUser(name: String, birthDate: Date) {
        let newUser = User(name: name, birthDate: birthDate)
        container.mainContext.insert(newUser)
        currentUser = newUser
        do {
            try container.mainContext.save()
        } catch {
            print("Failed to create new user: \(error)")
        }
    }
// fonction pour changer le currentUser
    
    func setCurrentUser(user: User) {
        currentUser = user
    }

//    fonction pour initialiser un jeu de donnée dans la BDD si elle est vide
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
                    Transaction(name: "Sample Test 1", amount: 10.0, account: sampleAccount1, date: Date()),
                    Transaction(name: "Sample Test 2", amount: 20.0, account: sampleAccount1, date: Date()),
                    Transaction(name: "Sample Test 3", amount: 30.0, account: sampleAccount1, date: Date())
                ]

                let sampleTransactions2 = [
                    Transaction(name: "Sample Test 4", amount: 40.0, account: sampleAccount2, date: Date()),
                    Transaction(name: "Sample Test 5", amount: 50.0, account: sampleAccount2, date: Date())
                ]

                for transaction in sampleTransactions1 {
                    context.insert(transaction)
                }

                for transaction in sampleTransactions2 {
                    context.insert(transaction)
                }

                try context.save()
                currentUser = sampleUser
                isInitialized = true
                print("Données d'exemple créées avec succès.")
            } else {
                currentUser = users.first ?? User(name: "Guest", birthDate: Date())
                isInitialized = true
                print("Des utilisateurs existent déjà, aucune donnée d'exemple n'a été créée.")
            }
        } catch {
            print("Erreur lors de la création des données d'exemple : \(error)")
        }
    }
    
// fonction pour créer un jeu de donné pour les preview
    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: User.self, Account.self, Transaction.self, configurations: config)

            let previewUser = User(name: "Preview User 1", birthDate: Date(), mail: "user@example.com", password: "password")
            container.mainContext.insert(previewUser)

            let previewAccount1 = Account(name: "Preview Account 1", user: previewUser)
            container.mainContext.insert(previewAccount1)

            let previewAccount2 = Account(name: "Preview Account 2", user: previewUser)
            container.mainContext.insert(previewAccount2)

            let previewTransactions1 = [
                Transaction(name: "Preview Test 1", amount: 10.0, account: previewAccount1, date: Date()),
                Transaction(name: "Preview Test 2", amount: 20.0, account: previewAccount1, date: Date()),
                Transaction(name: "Preview Test 3", amount: 30.0, account: previewAccount1, date: Date())
            ]

            let previewTransactions2 = [
                Transaction(name: "Preview Test 4", amount: 40.0, account: previewAccount2, date: Date()),
                Transaction(name: "Preview Test 5", amount: 50.0, account: previewAccount2, date: Date())
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
    
//    fonction pour vider la BDD
    func resetDatabase() {
        let context = container.mainContext
        do {
            let users: [User] = try context.fetch(FetchDescriptor<User>())
            for user in users {
                context.delete(user)
            }

            let accounts: [Account] = try context.fetch(FetchDescriptor<Account>())
            for account in accounts {
                context.delete(account)
            }

            let transactions: [Transaction] = try context.fetch(FetchDescriptor<Transaction>())
            for transaction in transactions {
                context.delete(transaction)
            }

            try context.save()
            print("Database reset successfully.")
        } catch {
            print("Failed to reset database: \(error)")
        }
    }
}


