//
//  AccountScreen.swift
//  AllAccount
//
//  Created by Fen on 21/05/2024.
//

import SwiftUI
import SwiftData

struct AccountScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Account.name, order: .forward) private var accounts: [Account]
    @State private var currentAccount : Account?
    @State private var showAddAccountModal : Bool = false

    var body: some View {
        NavigationView {
                   VStack {
                       if accounts.isEmpty {
                           VStack {
                               Text("Vous n'avez pas encore de compte")
                                   .font(.title)
                                   .padding()
                           }
                       } else if !accounts.filter({!$0.isActive}).isEmpty && accounts.filter({$0.isActive}).isEmpty{
                           VStack {
                               Text("Vous n'avez pas encore de compte actif")
                                   .font(.title)
                                   .padding()
                           }
                       }else {
                           List {
                               ForEach(accounts.filter { $0.isActive }) { account in
                                   AccountRow(account: account)
                               }
                               .onDelete(perform: desactivateAccounts)
                           }
                       }
                       ExtButtonAdd(text : "Créer",showModale: $showAddAccountModal)
                       .sheet(isPresented: $showAddAccountModal, content: {
                                                   AddAccountScreen()
                                               })
                   }
                   .navigationTitle("Comptes")
               }
           }

    private func desactivateAccounts(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                accounts[index].deactivate()
            }
        }
    }
}

#Preview {
    AccountScreen()
        .modelContainer(for: Account.self, inMemory: true)
        .modelContainer(for: Transaction.self, inMemory: true)
    
}

