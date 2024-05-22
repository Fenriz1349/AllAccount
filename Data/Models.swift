//
//  Item.swift
//  AllAccount
//
//  Created by Fen on 21/05/2024.
//

import Foundation
import SwiftData


//modele d'un Compte, il possède un nom, une liste de transaction et un statut actif ou pas.
//ce statue permet de conserver un historique des données même si le compte n'est plus utilisé
@Model
class Account: Identifiable {
    @Attribute(.unique) var name: String
    var isActive: Bool
    @Relationship var transactions: [Transaction] = []

    init(name: String, isActive: Bool = true) {
        self.name = name
        self.isActive = isActive
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
    @Attribute(.externalStorage) var accountName: String

    init(name: String, amount: Double, account: Account, isActive: Bool = true) {
        self.name = name
        self.amount = amount
        self.isActive = isActive
        self.account = account
        self.accountName = account.name
    }

    func deactivate() {
        self.isActive = false
    }

    func activate() {
        self.isActive = true
    }
}


