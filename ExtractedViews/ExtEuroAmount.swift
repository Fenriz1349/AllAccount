//
//  ExtEuroAmount.swift
//  AllAccount
//
//  Created by Fen on 27/05/2024.
//

import SwiftUI

struct ExtEuroAmount: View {
    var amount: Double
    @State private var animatedAmount: Double = 0.0

    private var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        let displayAmount = abs(animatedAmount)  
               if let formattedString = formatter.string(from: NSNumber(value: displayAmount)) {
                   return (amount >= 0.0 ? "+" : "-") + formattedString + "€"
               } else {
                   return DoubleToEuro(displayAmount)
               }
    }

    var body: some View {
        Text(formattedAmount)
            .onAppear {
                animateAmount()
            }
    }
    
    private func animateAmount() {
        let animationDuration = 1.5
        let steps = 100
        let stepTime = animationDuration / Double(steps)
        let increment = amount / Double(steps)

        animatedAmount = 0.0
        for step in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + stepTime * Double(step)) {
                animatedAmount = increment * Double(step)
            }
        }
    }
}

#Preview {
    ExtEuroAmount(amount: 1000)
}

