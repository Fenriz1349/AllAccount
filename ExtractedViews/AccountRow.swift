//
//  AccountRow.swift
//  AllAccount
//
//  Created by Fen on 23/05/2024.
//

import SwiftUI
import SwiftData

struct AccountRow: View {
    @Binding var account : Account
    var body: some View {
        NavigationLink {
            AccountDetailScreen(account:account)
        }label : {
            VStack(alignment: .leading) {
                Text(account.name)
                    .font(.headline)
                    .foregroundStyle(account.isActive ? .green : .red)
                Text(account.user.name)
                Text("Total: \(account.totalTransactionsAmount(), specifier: "%.2f")")
                    .foregroundColor(.blue)
            }
        }
    }
}

#Preview {
    let modelContainer = DataController.previewContainer
    let firstAccount = try! modelContainer.mainContext.fetch(FetchDescriptor<Account>()).first!
        
    return  AccountRow(account: .constant(firstAccount))
}
