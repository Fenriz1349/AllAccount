//
//  ContentView.swift
//  AllAccount
//
//  Created by Fen on 21/05/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject private var dataController: DataController
    @State private var selectedTab = 2
    var body: some View {
        TabView(selection: $selectedTab) {
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
    }
}

#Preview {
    ContentView()
        .environment(\.modelContext, DataController.previewContainer.mainContext)
        .environmentObject(DataController())
}
