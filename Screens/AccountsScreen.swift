//
//  AccountScreen.swift
//  AllAccount
//
//  Created by Fen on 21/05/2024.
//

import SwiftUI
import SwiftData

struct AccountsScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Account.name, order: .forward) private var accounts: [Account]
    @State private var currentAccount : Account?
    @State private var showAddAccountModal : Bool = false
    var body: some View {
        NavigationView {
                   ScrollView {
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
                           ForEach(accounts.filter { $0.isActive }.sorted{$0.totalTransactionsAmount >= $1.totalTransactionsAmount}){ account in
                                   AccountRow(account: account)
                                       .padding(.bottom,20)
                               }
                           }
                       ExtButtonAdd(text : "Nouveau Compte",showModale: $showAddAccountModal)
                       .sheet(isPresented: $showAddAccountModal, content: {
                                                   AddAccountScreen()
                                               })
                   }
                   .navigationTitle("Comptes")
               }
           }

}

#Preview {
    let modelContainer = DataController.previewContainer
    return AccountsScreen()
        .environment(\.modelContext, modelContainer.mainContext)
}

