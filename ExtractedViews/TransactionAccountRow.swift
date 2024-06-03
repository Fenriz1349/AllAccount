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
                RoundedRectangle(cornerRadius: 15.0)
                    .fill(.gray.opacity(0.1))
                    .overlay(RoundedRectangle(cornerRadius: 15.0).stroke(transaction.category.getColor(), lineWidth: 2))
                VStack(alignment: .leading) {
                    HStack {
                        Text(transaction.name)
                            .font(.headline)
                        Spacer()
                        Text(transaction.category.rawValue)
                            .foregroundStyle(transaction.category.getColor())
                    }
                    HStack {
                        Text("le \(DateToStringDayMonth(transaction.date))")
                        
                        Spacer()
                        ExtEuroAmount(amount:transaction.amount)
                            .foregroundStyle(transaction.amount >= 0 ? .green : .black)
                    }
                }.padding(5)
            }
            .frame(width : 300)
            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            
            
        }
    }
}

#Preview {
    let modelContainer = DataController.previewContainer
    let firstTransaction = try! modelContainer.mainContext.fetch(FetchDescriptor<Transaction>()).first!
    
    return  TransactionAccountRow(transaction: firstTransaction)
}
