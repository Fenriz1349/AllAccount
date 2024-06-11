//
//  Data.swift
//  AllAccount
//
//  Created by Fen on 23/05/2024.
//

import SwiftUI
import SwiftData

@MainActor
class DataController: ObservableObject {
    let container: ModelContainer
    @Published var currentUser: User
    @Published var isInitialized: Bool = false
    
    // Initialisation du ModelContainer, et création d'un utilisateur par défaut
    init(inMemory: Bool = true) {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: inMemory)
            self.container = try ModelContainer(for: User.self, Account.self, Transaction.self, configurations: config)
            self.currentUser = User(name: "Guest", birthDate: Date()) // Valeur par défaut pour currentUser
            initializeSampleData()
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
    
    // Fonction pour récupérer le premier utilisateur de la BDD ou l'utilisateur guest par défaut
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
    
    // Fonction pour créer un nouvel utilisateur, il n'est pas défini comme le currentUser
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
    
    // Fonction pour changer le currentUser
    func setCurrentUser(user: User) {
        currentUser = user
    }
    
    // Fonction pour initialiser un jeu de données dans la BDD si elle est vide
    func initializeSampleData() {
        let context = container.mainContext
        do {
            let users: [User] = try context.fetch(FetchDescriptor<User>())
            if users.isEmpty {
                let sampleUser = User(name: "Guts", birthDate: Date(), mail: "user@example.com", password: "password")
                context.insert(sampleUser)
                
//                let currentDate = Date()
                
                let currentAccount = Account(name: "Compte Courant", user: sampleUser, accountCategory: .bank)
                context.insert(currentAccount)
                
                let investmentAccount = Account(name: "Bourses", user: sampleUser, accountCategory: .action)
                context.insert(investmentAccount)
                
                let cashAccount = Account(name: "Cash", user: sampleUser, accountCategory: .cash)
                context.insert(cashAccount)
                
                let sampleTransactions :[Transaction] = [
                    // Janvier 2024
                    Transaction(name: "Solde Initial", amount: 500, account: cashAccount, date: Date(timeIntervalSinceReferenceDate: 723883200), category: .initialPositif),
                    Transaction(name: "Solde Initial", amount: -500, account: investmentAccount, date: Date(timeIntervalSinceReferenceDate: 723883200), category: .initialNegatif),
                    Transaction(name: "Loyer", amount: -1200.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 723883200), category: .rent),
                    Transaction(name: "Salaire", amount: 3000.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 723883200), category: .salary),
                    Transaction(name: "Courses alimentaires", amount: -200.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 723993600), category: .food),
                    Transaction(name: "Facture électricité", amount: -100.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 724252800), category: .energy),
                    Transaction(name: "Achat vêtements", amount: -150.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 724252800), category: .other),
                    Transaction(name: "Restaurant", amount: -80.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 724252800), category: .resto),
                    Transaction(name: "Bar", amount: -50.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 724809600), category: .bar),
                    Transaction(name: "Dividendes", amount: 20.0, account: investmentAccount, date: Date(timeIntervalSinceReferenceDate: 724809600), category: .dividends),
                    Transaction(name: "Achat divers", amount: -50.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 724809600), category: .other),
                    Transaction(name: "Achat livres", amount: -40.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 725068800), category: .other),
                    Transaction(name: "Achat jeux vidéo", amount: -60.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 725068800), category: .other),
                    Transaction(name: "Cinéma", amount: -20.0, account: cashAccount, date: Date(timeIntervalSinceReferenceDate: 725068800), category: .leasure),
                    Transaction(name: "Frais bancaires", amount: -5.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 725315200), category: .other),
                    Transaction(name: "Transport", amount: -30.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 725315200), category: .other),
                    Transaction(name: "Café", amount: -3.0, account: cashAccount, date: Date(timeIntervalSinceReferenceDate: 716076800), category: .other),
                    Transaction(name: "Abonnement streaming", amount: -15.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 725315200), category: .subscription),
                    Transaction(name: "Achat applications", amount: -10.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 725315200), category: .other),
                    Transaction(name: "Achat musique", amount: -8.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 725750400), category: .other),
                    Transaction(name: "Achat cadeau", amount: -25.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 725750400), category: .other),
                    Transaction(name: "Impôts", amount: -200.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 725750400), category: .other),

                    // Février 2024
                    Transaction(name: "Loyer", amount: -1200.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 725836800), category: .rent),
                    Transaction(name: "Retrait Liquide", amount: -400.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 725836800), category: .input),
                    Transaction(name: "Dépot Liquide", amount: 400.0, account: cashAccount, date: Date(timeIntervalSinceReferenceDate: 725836800), category: .output),
                    Transaction(name: "Salaire", amount: 3000.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 725836800), category: .salary),
                    Transaction(name: "Action Total", amount: -400.0, account: investmentAccount, date: Date(timeIntervalSinceReferenceDate: 725836800), category: .invest),
                    Transaction(name: "Courses alimentaires", amount: -220.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 725923200), category: .food),
                    Transaction(name: "Facture électricité", amount: -90.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 726307200), category: .energy),
                    Transaction(name: "Achat meubles", amount: -350.0, account: cashAccount, date: Date(timeIntervalSinceReferenceDate: 726307200), category: .other),
                    Transaction(name: "Restaurant", amount: -70.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 726307200), category: .resto),
                    Transaction(name: "Bar", amount: -40.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 726307200), category: .bar),
                    Transaction(name: "Dividendes", amount: 15.0, account: investmentAccount, date: Date(timeIntervalSinceReferenceDate: 726691200), category: .dividends),
                    Transaction(name: "Achat divers", amount: -60.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 726691200), category: .other),
                    Transaction(name: "Achat livres", amount: -30.0, account: cashAccount, date: Date(timeIntervalSinceReferenceDate: 727075200), category: .other),
                    Transaction(name: "Achat jeux vidéo", amount: -80.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 718416000), category: .other),
                    Transaction(name: "Cinéma", amount: -15.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 728035200), category: .leasure),
                    Transaction(name: "Frais bancaires", amount: -5.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 728035200), category: .other),
                    Transaction(name: "Transport", amount: -25.0, account: cashAccount, date: Date(timeIntervalSinceReferenceDate: 728035200), category: .other),
                    Transaction(name: "Café", amount: -2.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 728035200), category: .other),
                    Transaction(name: "Abonnement streaming", amount: -10.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 728121600), category: .subscription),
                    Transaction(name: "Achat applications", amount: -12.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 728121600), category: .other),
                    Transaction(name: "Achat musique", amount: -7.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 728208000), category: .other),
                    Transaction(name: "Achat cadeau", amount: -20.0, account: currentAccount, date: Date(timeIntervalSinceReferenceDate: 728208000), category: .other)
                
            ]


                for transaction in sampleTransactions {
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
    
    // Fonction pour créer un jeu de données pour les previews
    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: User.self, Account.self, Transaction.self, configurations: config)
            
            let previewUser = User(name: "Guts", birthDate: Date(), mail: "user@example.com", password: "password")
            container.mainContext.insert(previewUser)
            
            let currentDate = Date()
            
            let previewCurrentAccount = Account(name: "Compte Courant", user: previewUser, accountCategory: .bank)
            container.mainContext.insert(previewCurrentAccount)
            
            let previewInvestmentAccount = Account(name: "Bourses", user: previewUser, accountCategory: .action)
            container.mainContext.insert(previewInvestmentAccount)
            
            let previewCashAccount = Account(name: "Cash", user: previewUser, accountCategory: .cash)
            container.mainContext.insert(previewCashAccount)
            
            let previewTransactions: [Transaction] = [
                // Janvier 2024
                Transaction(name: "Solde Initial", amount: 500, account: previewCashAccount, date: Date(timeIntervalSinceReferenceDate: 723883200), category: .initialPositif),
                Transaction(name: "Solde Initial", amount: -500, account: previewInvestmentAccount, date: Date(timeIntervalSinceReferenceDate: 723883200), category: .initialNegatif),
                Transaction(name: "Loyer", amount: -1200.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 723883200), category: .rent),
                Transaction(name: "Salaire", amount: 3000.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 723883200), category: .salary),
                Transaction(name: "Courses alimentaires", amount: -200.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 723993600), category: .food),
                Transaction(name: "Facture électricité", amount: -100.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 724252800), category: .energy),
                Transaction(name: "Achat vêtements", amount: -150.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 724252800), category: .other),
                Transaction(name: "Restaurant", amount: -80.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 724252800), category: .resto),
                Transaction(name: "Bar", amount: -50.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 724809600), category: .bar),
                Transaction(name: "Dividendes", amount: 20.0, account: previewInvestmentAccount, date: Date(timeIntervalSinceReferenceDate: 724809600), category: .dividends),
                Transaction(name: "Achat divers", amount: -50.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 724809600), category: .other),
                Transaction(name: "Achat livres", amount: -40.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 725068800), category: .other),
                Transaction(name: "Achat jeux vidéo", amount: -60.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 725068800), category: .other),
                Transaction(name: "Cinéma", amount: -20.0, account: previewCashAccount, date: Date(timeIntervalSinceReferenceDate: 725068800), category: .leasure),
                Transaction(name: "Frais bancaires", amount: -5.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 725315200), category: .other),
                Transaction(name: "Transport", amount: -30.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 725315200), category: .other),
                Transaction(name: "Café", amount: -3.0, account: previewCashAccount, date: Date(timeIntervalSinceReferenceDate: 716076800), category: .other),
                Transaction(name: "Abonnement streaming", amount: -15.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 725315200), category: .subscription),
                Transaction(name: "Achat applications", amount: -10.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 725315200), category: .other),
                Transaction(name: "Achat musique", amount: -8.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 725750400), category: .other),
                Transaction(name: "Achat cadeau", amount: -25.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 725750400), category: .other),
                Transaction(name: "Impôts", amount: -200.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 725750400), category: .other),

                // Février 2024
                Transaction(name: "Loyer", amount: -1200.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 725836800), category: .rent),
                Transaction(name: "Retrait Liquide", amount: -400.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 725836800), category: .input),
                Transaction(name: "Dépot Liquide", amount: 400.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 725836800), category: .output),
                Transaction(name: "Salaire", amount: 3000.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 725836800), category: .salary),
                Transaction(name: "Action Total", amount: -400.0, account: previewInvestmentAccount, date: Date(timeIntervalSinceReferenceDate: 725836800), category: .invest),
                Transaction(name: "Courses alimentaires", amount: -220.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 725923200), category: .food),
                Transaction(name: "Facture électricité", amount: -90.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 726307200), category: .energy),
                Transaction(name: "Achat meubles", amount: -350.0, account: previewCashAccount, date: Date(timeIntervalSinceReferenceDate: 726307200), category: .other),
                Transaction(name: "Restaurant", amount: -70.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 726307200), category: .resto),
                Transaction(name: "Bar", amount: -40.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 726307200), category: .bar),
                Transaction(name: "Dividendes", amount: 15.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 726691200), category: .dividends),
                Transaction(name: "Achat divers", amount: -60.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 726691200), category: .other),
                Transaction(name: "Achat livres", amount: -30.0, account: previewCashAccount, date: Date(timeIntervalSinceReferenceDate: 727075200), category: .other),
                Transaction(name: "Achat jeux vidéo", amount: -80.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 718416000), category: .other),
                Transaction(name: "Cinéma", amount: -15.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 728035200), category: .leasure),
                Transaction(name: "Frais bancaires", amount: -5.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 728035200), category: .other),
                Transaction(name: "Transport", amount: -25.0, account: previewCashAccount, date: Date(timeIntervalSinceReferenceDate: 728035200), category: .other),
                Transaction(name: "Café", amount: -2.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 728035200), category: .other),
                Transaction(name: "Abonnement streaming", amount: -10.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 728121600), category: .subscription),
                Transaction(name: "Achat applications", amount: -12.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 728121600), category: .other),
                Transaction(name: "Achat musique", amount: -7.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 728208000), category: .other),
                Transaction(name: "Achat cadeau", amount: -20.0, account: previewCurrentAccount, date: Date(timeIntervalSinceReferenceDate: 728208000), category: .other)
            ]
            
            
            for transaction in previewTransactions {
                container.mainContext.insert(transaction)
            }
            
            try container.mainContext.save()
            
            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
    
    // Fonction pour vider la BDD
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
            isInitialized = false
            print("Database reset successfully.")
        } catch {
            print("Failed to reset database: \(error)")
        }
    }
}
