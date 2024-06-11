//
//  Item.swift
//  AllAccount
//
//  Created by Fen on 21/05/2024.
//

import SwiftUI
import SwiftData

@Model
class User : Identifiable {
    @Attribute(.unique) var id = UUID()
    var name : String
    var birthDate  : Date
    var mail : String
    var password : String
    @Relationship (deleteRule: .cascade) var accounts : [Account] = []
    var avatar : String
    
    init(name: String, birthDate: Date, mail: String = "", password: String = "", avatar : String = "guts") {
        self.name = name
        self.birthDate = birthDate
        self.mail = mail
        self.password = password
        self.avatar = avatar
    }
    func addAccount(_ account: Account) {
        accounts.append(account)
        account.user = self
    }
    func totalAccountAmount() -> Double {
        return accounts.reduce(0.0) { $0 + $1.totalTransactionsAmount }
    }
    
    func getAllTransactions () -> [Transaction]{
        var transactions : [Transaction] = []
        accounts.forEach { $0.transactions.forEach{transactions.append($0)}}
        return transactions
    }
}

enum AccountCategory : String,CaseIterable,Codable {

    case bank = "Banque"
    case action = "Action"
    case cryptoAccount = "Cryptomonnaie"
    case cash = "Cash"
    
    func getColor () -> Color {
        switch self {
        case .bank : return .yellow
        case .action : return .orange
        case .cryptoAccount : return .purple
        case .cash : return .green
        }
    }
}
//modele d'un Compte, il possède un nom, une liste de transaction et un statut actif ou pas.
//ce statue permet de conserver un historique des données même si le compte n'est plus utilisé
@Model
class Account: Identifiable {
    
    @Attribute(.unique) var name: String
    var isActive: Bool
    @Relationship var user: User
    @Relationship(deleteRule: .cascade) var transactions: [Transaction] = []
    var accountCategory: AccountCategory
    var dateCreated: Date
    
    var totalTransactionsAmount: Double {
        return transactions.reduce(0.0) { $0 + $1.amount }
    }
    
    init(name: String, isActive: Bool = true, user: User, accountCategory: AccountCategory, dateCreated: Date = Date()) {
        self.name = name
        self.isActive = isActive
        self.user = user
        self.accountCategory = accountCategory
        self.dateCreated = dateCreated
        user.addAccount(self)
    }
    
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
        transaction.account = self
    }
    
    func removeTransaction(_ transaction: Transaction) {
           if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
               transactions.remove(at: index)
           }
       }
    
    func deactivate() {
        self.isActive = false
    }
    
    func activate() {
        self.isActive = true
    }
    
    
    func totalTransactionsCategory(_ category : TransactionCategory) -> Double {
        return transactions.filter{$0.category == category}.reduce(0.0) { $0 + $1.amount }
    }
}
enum TransactionCategory : String,CaseIterable,Codable {
    case salary = "Salaires"
    case sales = "Ventes"
    case rent = "Loyer"
    case invest = "Investissement"
    case dividends = "Dividendes"
    case food = "Courses"
    case resto = "Resto"
    case bar = "Bar"
    case subscription = "Abonnement"
    case leasure = "Loisir"
    case energy = "Energie"
    case car = "Voiture"
    case other = "Autre"
    case input = "Apport"
    case output = "Retrait"
    case initialPositif = "Solde Initial Positif"
    case initialNegatif = "Solde Initial Négatif"
    
    func isGain () -> Bool {
        switch self {
        case .salary,.dividends,.sales,.initialPositif,.input : return true
        default : return false
        }
    }
    func getColor() -> Color {
            switch self {
            case .salary, .dividends,.initialPositif,.input:
                return .green
            case .sales, .invest:
                return .blue
            case .rent, .subscription, .energy:
                return .red
            case .food, .resto, .bar, .initialNegatif,.output:
                return .orange
            case .leasure, .car:
                return .purple
            case .other:
                return .gray
            }
        }
}
//modele d'une transaction
@Model
class Transaction: Identifiable {
    @Attribute(.unique) var id = UUID()
    var name: String
    var amount: Double
    @Relationship var account: Account
    var date : Date
    var category : TransactionCategory

    init(name: String, amount: Double, account: Account,date : Date, category : TransactionCategory) {
        self.name = name
        self.amount = amount
        self.date = date
        self.account = account
        self.category = category
        account.addTransaction(self)
    }
    
    func delete() {
            account.removeTransaction(self)
        }
}

//struct pour gérer l'affichage des graphiques
struct PieDatas : Identifiable {
    let id = UUID()
    let name : String
    let amount : Double
    let color : Color
}

