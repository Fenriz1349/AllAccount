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
    @Query var users: [User]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                if let currentUser = users.first {
                    Text("Bonjour \(currentUser.name)")
                } else {
                    Text("Aucun Profil")
                }
            }
            .navigationTitle("Profil")
        }
    }
}

#Preview {
    ProfilScreen()
        .modelContainer(for: User.self, inMemory: true)
}
