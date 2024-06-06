//
//  ExtPiePercentAccountCat.swift
//  AllAccount
//
//  Created by Fen on 31/05/2024.
//

import SwiftUI
import SwiftData
import Charts

struct ExtPiePercentAccountCat: View {
    var transactions : [Transaction]
    private var total :Double {
        transactions.reduce(0.0) { $0 + abs($1.amount) }
    }

    var pieDatas: [PieDatas] {
        let distinctCategories = Set(transactions.map { $0.category })
        return SortedByPosThenNeg(distinctCategories.map { category in
            let categoryTransactions = transactions.filter { $0.category == category }
            let totalAmount = categoryTransactions.reduce(0.0) { $0 + $1.amount }
            return PieDatas(name: category.rawValue, amount: totalAmount, color: category.getColor())
        })
    }
    var body: some View {
            VStack {
                Chart {
                    ForEach(pieDatas) { data in
                        SectorMark(
                            angle: .value("Amount", data.amount),
                            innerRadius: .ratio(0.5),
                            angularInset: 1
                        )
                        .foregroundStyle(data.color)
                        .cornerRadius(10.0)
                        .annotation(position: .overlay) {
                            Text(stringIfSupTo5(data.amount*100/total))
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
                Spacer()
            }
            .padding()
        }
                                            }
                                            
#Preview {
    let modelContainer = DataController.previewContainer
    let firstAccount = try! modelContainer.mainContext.fetch(FetchDescriptor<Account>()).first!
    
    return  ExtPiePercentAccountCat( transactions: firstAccount.transactions)
}
        
