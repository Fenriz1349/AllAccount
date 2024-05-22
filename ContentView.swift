//
//  ContentView.swift
//  AllAccount
//
//  Created by Fen on 21/05/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isInitialized = false

    var body: some View {
        TabView {
            TransactionScreen()
                .tabItem {
                    Label("Transactions", systemImage: "square.and.pencil")
                }
            AccountScreen()
                .tabItem {
                    Label("Comptes", systemImage: "list.dash")
                }
            ProfilScreen()
                .tabItem {
                    Label("Profil", systemImage: "person")
                }
        }
        .onAppear {
            if !isInitialized {
                initializeGuestUser()
                isInitialized = true
            }
        }
    }

    private func initializeGuestUser() {
        do {
            let users: [User] = try modelContext.fetch(FetchDescriptor<User>())
            if users.isEmpty {
                let guestUser = User(name: "Invité", birthDate: Date(), mail: "", password: "")
                modelContext.insert(guestUser)
                try modelContext.save()
                print("Invité ajouté")
            }
        } catch {
            print("Failed to fetch or save guest user: \(error)")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Account.self, inMemory: true)
        .modelContainer(for: Transaction.self, inMemory: true)
}


