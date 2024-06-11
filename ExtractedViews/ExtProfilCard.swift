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
                .fill(.white.opacity(5))
                .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.blue, lineWidth: 4))
            HStack{
                Image(user.avatar)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 5)
                    .padding(.leading,10)
                Spacer()
                VStack(alignment: .leading) {
                    Text(user.name)
                        .fontWeight(.bold)
                        .font(.system(size: 30))
                        .padding(.bottom,10)
                    ExtEuroAmount(amount: balance)
                        .fontWeight(.heavy)
                        .font(.system(size: 30))
                        .foregroundStyle(balance >= 0 ? .green : .red)
                }
                .padding()
            }
        }
        .frame(width: 325,height: 125)
    }
}

#Preview {
    let modelContainer = DataController.previewContainer
    let firstUser = try! modelContainer.mainContext.fetch(FetchDescriptor<User>()).first!
    
    return  ExtProfilCard(user: firstUser)
}
