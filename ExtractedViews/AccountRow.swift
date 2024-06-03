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
                VStack(alignment: .leading) {
                    ExtBlueRibbon(text: account.name)
                    HStack {
                        Text (account.accountCategory.rawValue)
                            .foregroundStyle(account.accountCategory.getColor())
                        Spacer()
                        ExtEuroAmount(amount:account.totalTransactionsAmount())
                            .foregroundStyle(account.totalTransactionsAmount() >= 0 ? .green : .red)
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
    let firstAccount = try! modelContainer.mainContext.fetch(FetchDescriptor<Account>()).first!
        
    return  AccountRow(account: firstAccount)
}
