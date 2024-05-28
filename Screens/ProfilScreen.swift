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
    @State var balance : Double = 0.0
    
    private var currentUser: User {
        dataController.currentUser
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("Bonjour \(currentUser.name)")
                HStack{
                    Text("Votre solde Total est de ")
                    ExtEuroAmmount(amount: balance)
                        .foregroundStyle(balance >= 0 ? .green : .red)
                }
            }
            .navigationTitle("Profil")
        }
        .onAppear{
            balance = currentUser.totalAccountAmount()
        }
    }
}

#Preview {
    ProfilScreen()
        .environment(\.modelContext, DataController.previewContainer.mainContext)
        .environmentObject(DataController())
}

