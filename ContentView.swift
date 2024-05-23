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
    @State private var selectedTab = 2
    @StateObject private var dataController = DataController()
    
    var body: some View {
        TabView (selection: $selectedTab){
            TransactionScreen()
                .tabItem {
                    Label("Transactions", systemImage: "eurosign")
                }
                .tag(0)
            AccountScreen()
                .tabItem {
                    Label("Comptes", systemImage: "building.columns.fill")
                }
                .tag(1)
            ProfilScreen()
                .tabItem {
                    Label("Profil", systemImage: "person")
                }
                .tag(2)
        }
        .environment(\.modelContext, dataController.container.mainContext)
        .modelContainer(for: [User.self, Account.self, Transaction.self], inMemory: false)
        .onAppear {
            print("test")
            if !dataController.isInitialized {
                dataController.initializeSampleData()
            }
        }

    }
}

#Preview {
    ContentView()
        .modelContainer(for: [User.self, Account.self, Transaction.self], inMemory: false)
}


