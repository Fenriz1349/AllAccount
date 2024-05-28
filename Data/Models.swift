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
    @Relationship var accounts : [Account] = []
    
    init(name: String, birthDate: Date, mail: String = "", password: String = "") {
        self.name = name
        self.birthDate = birthDate
        self.mail = mail
        self.password = password
    }
    func addAccount(_ account: Account) {
        accounts.append(account)
        account.user = self
    }
    func totalAccountAmount() -> Double {
        return accounts.reduce(0.0) { $0 + $1.totalTransactionsAmount() }
    }
}

enum AccountType : String,CaseIterable,Codable {

    case bank = "Banque"
    case action = "Action"
    case cryptoAccount = "Cryptomonnaie"
    case cash = "Cash"
    
    func getColor () -> Color {
        switch self {
        case .bank : return .gray
        case .action : return .yellow
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
    @Relationship var user : User
    @Relationship var transactions: [Transaction] = []
    var accountType : AccountType

    init(name: String, isActive: Bool = true, user: User, accountType : AccountType) {
        self.name = name
        self.isActive = isActive
        self.user = user
        self.accountType = accountType
        user.addAccount(self)
    }
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
        transaction.account = self
    }
    
    func deactivate() {
        self.isActive = false
    }

    func activate() {
        self.isActive = true
    }

    func totalTransactionsAmount() -> Double {
        return transactions.reduce(0.0) { $0 + $1.amount }
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
    
    func isGain () -> Bool {
        switch self {
        case .salary,.dividends,.sales : return true
        default : return false
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
}
