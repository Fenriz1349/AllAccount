//
//  Functions.swift
//  AllAccount
//
//  Created by Fen on 21/05/2024.
//

import Foundation
import SwiftUI

//fonction pour retourner la date au format JJ/MM
func DateToStringDayMonth(_ date : Date) -> String {
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "dd/MM"
       return dateFormatter.string(from: date)
   }

//fonction pour retourner un Double au format Euros avec 2 decimales
func DoubleToEuro (_ number : Double) -> String {
    return String(format: "%.2f€", number)
}

//fonction pour retourner un Double au format pourcentage sans decimale
func DoubleToPercent (_ number : Double) -> String {
    return String("\(Int(number))%")
}

func getPositiveBalance (_ transactions : [Transaction]) -> Double {
    return transactions.filter{$0.category.isGain()}.reduce(0.0) { $0 + $1.amount }
}
func getNegativeBalance (_ transactions : [Transaction]) -> Double {
    return transactions.filter{!$0.category.isGain()}.reduce(0.0) { $0 + $1.amount }
}

func stringIfSupTo5 (_ number : Double)-> String {
    return abs(number) >= 5.0 ? DoubleToPercent(number) : ""
}
//fonction pour trier des données des charts par ordre décroissant les valeurs positives, puis les valeurs negatives
func SortedByPosThenNeg (_ pieDatas :[PieDatas]) -> [PieDatas] {
    var positives = pieDatas.filter {$0.amount >= 0.0}
    var negatives = pieDatas.filter {$0.amount < 0.0}
    positives.sort{$0.amount >= $1.amount}
    negatives.sort{abs($0.amount) >= abs($1.amount)}
    return positives+negatives
}
