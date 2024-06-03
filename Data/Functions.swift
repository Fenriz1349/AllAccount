//
//  Functions.swift
//  AllAccount
//
//  Created by Fen on 21/05/2024.
//

import Foundation
import SwiftUI
// fonction pour renvoer nil sur le format n'est pas bon, et la string en Double si c'est un Int, un Double ou un Double avec une virgule
func stringToDouble (_ test : String) -> Double? {
    if let double = Double(test) {
        return double
    }else {
        if let int = Int(test) {
            return Double(int)
        }else {
            let array = test.split(separator: ",")
            if (array.count == 2) && (Int(array[0]) != nil) && (Int(array[1]) != nil) {
                return Double(array.joined(separator: "."))
            }else {
                return nil
            }
        }
    }
}

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
