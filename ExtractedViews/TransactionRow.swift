//
//  TransactionRow.swift
//  AllAccount
//
//  Created by Fen on 27/05/2024.
//

import SwiftUI
import SwiftData

struct TransactionRow: View {
    var transaction : Transaction
    var body: some View {
        NavigationLink {
            TransactionDetailScreen()
        }label : {
            VStack(alignment: .leading) {
                Text(transaction.name)
                    .font(.headline)
                    .foregroundStyle(transaction.isActive ? .green : .red)
                Text(transaction.account.name)
                Text("montant: \(transaction.amount, specifier: "%.2f")")
                    .foregroundColor(.blue)
            }
        }
    }
}

#Preview {
    let modelContainer = DataController.previewContainer
    let firstTransaction = try! modelContainer.mainContext.fetch(FetchDescriptor<Transaction>()).first!
        
    return  TransactionRow(transaction: firstTransaction)
}
