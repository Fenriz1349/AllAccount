//
//  ContentView.swift
//  AllAccount
//
//  Created by Fen on 21/05/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            AccountScreen()
                .tabItem {
                    Label("Accounts", systemImage: "list.dash")
                }

            TransactionScreen()
                .tabItem {
                    Label("Transactions", systemImage: "square.and.pencil")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Account.self, inMemory: true)
        .modelContainer(for: Transaction.self, inMemory: true)
}


