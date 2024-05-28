//
//  TransactionAccountRow.swift
//  AllAccount
//
//  Created by Fen on 27/05/2024.
//

import SwiftUI
import SwiftData

struct TransactionAccountRow: View {
    var transaction : Transaction
    var body: some View {
        NavigationLink {
            TransactionDetailScreen(transaction: transaction)
        }label : {
            ZStack {
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                    .fill(.gray.opacity(0.1))
                VStack(alignment: .leading) {
                    HStack {
                        Text(transaction.name)
                            .font(.headline)
                        Spacer()
                        Text(transaction.category.rawValue)
                    }
                    HStack {
                        Text("le \(DateToStringDayMonth(transaction.date))")
                        Text(transaction.category.rawValue)
                        Spacer()
                        ExtEuroAmmount(amount:transaction.amount)
                            .foregroundStyle(transaction.amount >= 0 ? .green : .black)
                    }
                }
                .padding(.horizontal,10)
            }
            .frame(width : 300,height: 100)
        }
    }
}

#Preview {
    let modelContainer = DataController.previewContainer
    let firstTransaction = try! modelContainer.mainContext.fetch(FetchDescriptor<Transaction>()).first!
    
    return  TransactionAccountRow(transaction: firstTransaction)
}
