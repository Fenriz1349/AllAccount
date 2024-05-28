//
//  ExtBlueRibbon.swift
//  AllAccount
//
//  Created by Fen on 28/05/2024.
//

import SwiftUI

struct ExtBlueRibbon: View {
    var text : String = "test de rubban"
    var body: some View {
        ZStack{
            Rectangle()
                .fill(.blue.opacity(0.5))
                .frame(height: 30)
            HStack{
                Text(text)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.leading,20)
                Spacer()
            }
            
                
        }
        
    }
}

#Preview {
    ExtBlueRibbon()
}
