//
//  ExtPieBalance.swift
//  AllAccount
//
//  Created by Fen on 31/05/2024.
//

import SwiftUI
import SwiftData
import Charts

struct ExtPieBalance: View {
    var transactions : [Transaction]
    private var positiveBalance : Double {
        return getPositiveBalance(transactions)
    }
    private var negativeBalance : Double {
        return getNegativeBalance(transactions)
    }
    private var total : Double {
        return positiveBalance+abs(negativeBalance)
    }
    var body: some View {
        Chart {
            SectorMark(
                angle: .value("Completion", positiveBalance),
                innerRadius: .ratio(0.5),
                angularInset: 2.0
            )
            .annotation(position: .overlay) {
                Text(stringIfSupTo5(positiveBalance * 100 / total))
                    .fontWeight(.bold)
            }
            .cornerRadius(25)
            .foregroundStyle(.green)
            
            SectorMark(
                angle: .value("UnCompletion", negativeBalance),
                innerRadius: .ratio(0.5),
                angularInset: 2.0
            )
            .annotation(position: .overlay) {
                Text(DoubleToPercent(abs(negativeBalance * 100 / total)))
                    .fontWeight(.bold)
            }
            .cornerRadius(25)
            .foregroundStyle(.red)
        }
        .frame(height: 150)
    }
}


#Preview {
    let modelContainer = DataController.previewContainer
    let firstUser = try! modelContainer.mainContext.fetch(FetchDescriptor<User>()).first!
    return ExtPieBalance(transactions: firstUser.getAllTransactions())
}
