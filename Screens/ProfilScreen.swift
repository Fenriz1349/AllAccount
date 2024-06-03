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
        ScrollView {
            VStack(alignment: .center) {
                ExtProfilCard(user: currentUser)
                Text("Balance")
                    .font(.title)
                ExtPieBalance(transactions: currentUser.getAllTransactions())
                Text("Repartition des comptes")
                    .font(.title)
                ExtPiePercentAllAccount()
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

