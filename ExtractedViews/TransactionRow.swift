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
            TransactionDetailScreen(transaction: transaction)
        }label : {
            VStack(alignment: .leading) {
                Text(transaction.name)
                    .font(.headline)
                Text(transaction.account.name)
                HStack {
                    Text("montant:")
                    ExtEuroAmmount(amount:transaction.amount)
                }
            }
        }
    }
}

#Preview {
    let modelContainer = DataController.previewContainer
    let firstTransaction = try! modelContainer.mainContext.fetch(FetchDescriptor<Transaction>()).first!
        
    return  TransactionRow(transaction: firstTransaction)
}
