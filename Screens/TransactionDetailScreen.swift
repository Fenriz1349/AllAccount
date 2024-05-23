//
//  TransactionDetailScreen.swift
//  AllAccount
//
//  Created by Fen on 22/05/2024.
//

import SwiftUI
import SwiftData

struct TransactionDetailScreen: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    private func toggleTransactionStatus(_ transaction: Transaction) {
        withAnimation {
            transaction.isActive.toggle()
        }
    }

//    private func deleteTransactions(at offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(transactions[index])
//            }
//        }
//    }
}

#Preview {
    TransactionDetailScreen()
        .modelContainer(for: Transaction.self, inMemory: true)
    
}
