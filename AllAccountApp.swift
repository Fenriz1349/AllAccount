//
//  AllAccountApp.swift
//  AllAccount
//
//  Created by Fen on 21/05/2024.
//

import SwiftUI
import SwiftData

@main
struct AllAccountApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Account.self,
            Transaction.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
