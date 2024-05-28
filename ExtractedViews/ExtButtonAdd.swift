//
//  ExtButtonAdd.swift
//  AllAccount
//
//  Created by Fen on 22/05/2024.
//

import SwiftUI

struct ExtButtonAdd: View {
    var text : String
    @Binding var showModale : Bool
    var body: some View {
        Button(action: { showModale.toggle() }) {
            Label(text, systemImage: "plus")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(25)
        }
    }
}

#Preview {
    ExtButtonAdd(text : "Créer", showModale: .constant(true))
}
