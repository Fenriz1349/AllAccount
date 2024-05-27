//
//  ExtEuroAmmount.swift
//  AllAccount
//
//  Created by Fen on 27/05/2024.
//

import SwiftUI

struct ExtEuroAmmount: View {
    var amount: Double
    @State private var animatedAmount: Double = 0.0

    private var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        if let formattedString = formatter.string(from: NSNumber(value: animatedAmount)) {
            return formattedString + "€"
        } else {
            return String(format: "%.2f€", animatedAmount)
        }
    }

    var body: some View {
        Text(formattedAmount)
            .foregroundStyle(animatedAmount >= 0 ? .green : .red)
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
    ExtEuroAmmount(amount: 1000)
}

