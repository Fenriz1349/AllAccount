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
    @Query private var accounts: [Account]
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
                                   NavigationLink {
                                       AccountDetail(account:account)
                                   }label : {
                                       VStack(alignment: .leading) {
                                           Text(account.name)
                                               .font(.headline)
                                               .foregroundStyle(account.isActive ? .green : .red)
                                           Text(account.user.name)
                                           Text("Total: \(account.totalTransactionsAmount(), specifier: "%.2f")")
                                               .foregroundColor(.blue)
                                       }
                                   }
                               }
                               .onDelete(perform: desactivateAccounts)
                           }
                       }
                       Button(action: { showAddAccountModal.toggle() }) {
                           Label("Ajouter", systemImage: "plus")
                               .padding()
                               .background(Color.blue)
                               .foregroundColor(.white)
                               .cornerRadius(8)
                       }
                       .sheet(isPresented: $showAddAccountModal, content: {
                                                   AddAccountScreen()
                                               })
                   }
                   .navigationTitle("Comptes")
                   .toolbar {
                       ToolbarItem(placement: .navigationBarTrailing) {
                           EditButton()
                       }
                   }
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
}

