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
            VStack(alignment: .leading) {
                HStack{
                    Text(account.name)
                        .font(.headline)
                        .foregroundStyle(.blue )
                    Text (account.accountType.rawValue)
                        .foregroundStyle(account.accountType.getColor())
                }
                
                Text(account.user.name)
                HStack {
                    Text("Total:")
                    ExtEuroAmmount(amount:account.totalTransactionsAmount())
                }
            }
        }
    }
}

#Preview {
    let modelContainer = DataController.previewContainer
    let firstAccount = try! modelContainer.mainContext.fetch(FetchDescriptor<Account>()).first!
        
    return  AccountRow(account: firstAccount)
}
