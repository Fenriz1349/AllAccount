//
//  ExtPiePercentRepartition.swift
//  AllAccount
//
//  Created by Fen on 30/05/2024.
//

import SwiftUI
import SwiftData
import Charts

struct ExtPiePercentAllAccount: View {
    @Query var accounts: [Account]
    @EnvironmentObject private var dataController: DataController
    
    private var currentUser: User {
        dataController.currentUser
    }
    
    var pieDatas: [PieDatas] {
            accounts.map { PieDatas(name: $0.name, amount: $0.totalTransactionsAmount(), color: $0.accountCategory.getColor()) }
                   .sorted(by: { abs($0.amount) > abs($1.amount) })
        }
    private var balance: Double {
        currentUser.totalAccountAmount()
    }
    private var sumAllBalances : Double {
        pieDatas.map{$0.amount}.reduce(0.0){$0+abs($1)}
    }
    var body: some View {
        VStack {
            Chart {
                ForEach(pieDatas) { data in
                    SectorMark(
                        angle: .value("Amount", abs(data.amount)),
                        innerRadius: .ratio(0.5),
                        angularInset: 1
                    )
                    .foregroundStyle(data.color)
                    .cornerRadius(10.0)
                    .annotation(position: .overlay) {
                        Text(stringIfSupTo5(data.amount*100 / sumAllBalances))
                            .fontWeight(.bold)
                    }
                }
            }
            .frame(height: 200)
            .padding()
            
            VStack(alignment: .leading, spacing: 4) {
                ForEach(pieDatas) { data in
                    HStack{
                        Text(data.name)
                            .font(.subheadline)
                            .foregroundStyle(data.color)
                        ExtEuroAmount(amount: data.amount)
                    }
                    
                }
            }
            .padding(.top, 8)
        }
        .padding()
    }
}

#Preview {
    ExtPiePercentAllAccount()
        .environment(\.modelContext, DataController.previewContainer.mainContext)
        .environmentObject(DataController())
}


