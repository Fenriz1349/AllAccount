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
