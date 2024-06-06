//
//  AccountRow.swift
//  AllAccount
//
//  Created by Fen on 23/05/2024.
//

import SwiftUI
import SwiftData

struct AccountRow: View {
    var account : Account
    var body: some View {
        NavigationLink {
            AccountDetailScreen(account:account)
        }label : {
            ZStack {
                RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                    .fill(.gray.opacity(0.1))
                    .overlay(RoundedRectangle(cornerRadius: 15.0).stroke(account.accountCategory.getColor(), lineWidth: 2))
                HStack {
                    VStack(alignment: .leading) {
                        Text(account.name)
                        HStack {
                            Text (account.accountCategory.rawValue)
                                .foregroundStyle(account.accountCategory.getColor())
                            Spacer()
                            ExtEuroAmount(amount:account.totalTransactionsAmount)
                                .foregroundStyle(account.totalTransactionsAmount >= 0 ? .green : .red)
                        }
                    }
                    .padding(.horizontal,10)
                Image(systemName: "chevron.right")
                        .fontWeight(.black)
                        .padding(.horizontal,5)
                }
            }
            .frame(width : 320,height: 100)
        }
    }
}

#Preview {
    let modelContainer = DataController.previewContainer
    let firstAccount = try! modelContainer.mainContext.fetch(FetchDescriptor<Account>()).first!
        
    return  AccountRow(account: firstAccount)
}
