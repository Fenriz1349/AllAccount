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
    @Environment(\.modelContext) private var modelContext
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.modelContext, dataController.container.mainContext)
                .environmentObject(dataController)
                .onAppear {
                    dataController.resetDatabase()
                    if !dataController.isInitialized {
                        dataController.initializeSampleData()
                    }
                }
        }
    }
}
