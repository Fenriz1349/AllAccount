//
//  ProfilScreen.swift
//  AllAccount
//
//  Created by Fen on 22/05/2024.
//

import SwiftUI
import SwiftData

struct ProfilScreen: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var dataController: DataController

    private var currentUser: User {
        dataController.currentUser
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("Bonjour \(currentUser.name)")
                HStack{
                    Text("Votre solde Total est de ")
                    ExtEuroAmmount(amount: currentUser.totalAccountAmount())
                }
               
                Button(action: {
                    dataController.resetDatabase()
                    dataController.initializeSampleData()
                }) {
                    Text("Creer data")
                }
            }
            .navigationTitle("Profil")
        }
    }
}

#Preview {
    ProfilScreen()
        .environment(\.modelContext, DataController.previewContainer.mainContext)
        .environmentObject(DataController())
}

