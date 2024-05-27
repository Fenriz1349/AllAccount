//
//  Item.swift
//  AllAccount
//
//  Created by Fen on 21/05/2024.
//

import Foundation
import SwiftData

@Model
class User : Identifiable {
    @Attribute(.unique) var id = UUID()
    var name : String
    var birthDate  : Date
    var mail : String
    var password : String
    @Relationship var accounts : [Account]
    
    init(name: String, birthDate: Date, mail: String = "", password: String = "", accounts: [Account] = []) {
        self.name = name
        self.birthDate = birthDate
        self.mail = mail
        self.password = password
        self.accounts = accounts
    }
    
    func totalAccountAmount() -> Double {
        return accounts.reduce(0) { $0 + $1.totalTransactionsAmount() }
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

    init(name: String, isActive: Bool = true, user: User, transactions: [Transaction] = []) {
        self.name = name
        self.isActive = isActive
        self.user = user
        self.transactions = transactions
    }

    func deactivate() {
        self.isActive = false
    }

    func activate() {
        self.isActive = true
    }

    func totalTransactionsAmount() -> Double {
        return transactions.filter { $0.isActive }.reduce(0) { $0 + $1.amount }
    }
}

//modele d'une transaction, elle peut etre active ou non et ne sera pas supprimer pour conserver un historique précis
@Model
class Transaction: Identifiable {
    @Attribute(.unique) var id = UUID()
    var name: String
    var amount: Double
    var isActive: Bool
    @Relationship var account: Account
    var date : Date

    init(name: String, amount: Double, account: Account, isActive: Bool = true,date : Date) {
        self.name = name
        self.amount = amount
        self.isActive = isActive
        self.account = account
        self.date = date
    }

    func deactivate() {
        self.isActive = false
    }

    func activate() {
        self.isActive = true
    }
}



