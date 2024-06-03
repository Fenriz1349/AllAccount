//
//  ExtProfilCard.swift
//  AllAccount
//
//  Created by Fen on 30/05/2024.
//

import SwiftUI
import SwiftData

struct ExtProfilCard: View {
    var user : User
    private var balance : Double {
        return user.getAllTransactions().reduce(0.0) { $0 + $1.amount }
    }
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .fill(.blue.opacity(50))
            HStack{
                Image(user.avatar)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 5)
                    .padding(.leading,10)
                VStack {
                    Text(user.name)
                        .fontWeight(.bold)
                        .font(.system(size: 30))
                        .padding(.bottom,50)
                    ExtEuroAmount(amount: balance)
                        .fontWeight(.heavy)
                        .font(.system(size: 30))
                        .foregroundStyle(balance >= 0 ? .green : .red)
                }
            }
            .foregroundStyle(Color.white)
        }
        .frame(width: 300,height: 150)
    }
}

#Preview {
    let modelContainer = DataController.previewContainer
    let firstUser = try! modelContainer.mainContext.fetch(FetchDescriptor<User>()).first!
    
    return  ExtProfilCard(user: firstUser)
}
