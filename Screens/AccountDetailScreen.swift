//
//  AccountDetail.swift
//  AllAccount
//
//  Created by Fen on 21/05/2024.
//

import SwiftUI
import SwiftData

struct AccountDetailScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    var account: Account
    var positiveTransactions: [Transaction] {
            account.transactions.filter { $0.category.isGain() }
        }
        
    var negativeTransactions: [Transaction] {
            account.transactions.filter { !$0.category.isGain() }
    }
    @State private var newName: String
    @State private var newIsActive: Bool
    @State private var showValidateAlert = false
    @State private var isEditing = false
    @State private var newCategory : AccountCategory
    @State private var maxHeight: CGFloat = 0

    init(account: Account) {
        self.account = account
        _newName = State(initialValue: account.name)
        _newIsActive = State(initialValue: account.isActive)
        _newCategory = State(initialValue: account.accountCategory)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if isEditing {
                    HStack{
                        TextField("Nouveau nom", text: $newName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Toggle("Statut", isOn: $newIsActive)
                            .padding()
                    }
                    Picker ("Type :",selection: $newCategory) {
                        ForEach (AccountCategory.allCases, id: \.self) {accountCategory in
                            Text(accountCategory.rawValue).tag(accountCategory as AccountCategory?)
                        }
                    }.pickerStyle(.segmented)
                    HStack {
                        Button(action: {
                            isEditing.toggle()
                        }) {
                            Text("Annuler")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(8)
                        }
                        .padding(.bottom)
                        
                        Button(action: {
                            showValidateAlert.toggle()
                        }) {
                            Text("Valider")
                                .foregroundColor(.white)
                                .padding()
                                .background(.green)
                                .cornerRadius(8)
                        }
                        .padding(.bottom)
                    }
                } else {
                    VStack {
                        HStack {
                            Text(account.name)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .foregroundStyle(account.isActive ? .green : .red)
                                .font(.system(size: 24))
                            Text("\(account.isActive ? "Actif" : "Inactif")")
                        }
                        HStack {
                            Text("Type :")
                            Text(account.accountCategory.rawValue)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .foregroundStyle(account.accountCategory.getColor())
                        }
                        HStack{
                            Text("Total: ")
                            ExtEuroAmount(amount: account.totalTransactionsAmount)
                                .foregroundStyle(account.totalTransactionsAmount >= 0.0 ? .green : .red)
                        }
                    }
                    .padding(.bottom,12)
                    Button(action: {
                        newName = account.name
                        newIsActive = account.isActive
                        newCategory = account.accountCategory
                        isEditing.toggle()
                    }) {
                        Text("Modifier")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.bottom,24)
            VStack {
                Text("Répartition")
                    .font(.title)
                ExtPiePercentAccountCat(transactions: account.transactions)
                    .padding(.top,-25)
                HStack{
                    VStack {
                        Text("Entrées")
                            .font(.title)
                        HStack{
                            Text("Total: ")
                            ExtEuroAmount(amount: positiveTransactions.reduce(0.0) { $0 + $1.amount })
                                .foregroundStyle(positiveTransactions.reduce(0.0) { $0 + $1.amount } >= 0.0 ? .green : .red)
                        }
                        ExtPiePercentAccountCat(transactions: positiveTransactions)
                            .background(GeometryReader {
                                Color.clear.preference(key: ViewHeightKey.self, value: $0.frame(in: .local).size.height)
                            })
                            .padding(.top,-75)
                    }
                    VStack {
                        Text("Sortie")
                            .font(.title)
                        HStack{
                            Text("Total: ")
                            ExtEuroAmount(amount: negativeTransactions.reduce(0.0) { $0 + $1.amount })
                                .foregroundStyle(negativeTransactions.reduce(0.0) { $0 + $1.amount } >= 0.0 ? .green : .red)
                        }
                        ExtPiePercentAccountCat(transactions: negativeTransactions)
                            .background(GeometryReader {
                                Color.clear.preference(key: ViewHeightKey.self, value: $0.frame(in: .local).size.height)
                            })
                            .padding(.top,-75)
                    }
                }
            }
            .padding(.bottom,24)
            ForEach(account.transactions) { transaction in
                TransactionAccountRow(transaction: transaction)
            }
        }
        .padding()
        .alert("Valider les modifications", isPresented: $showValidateAlert, actions: {
            Button("Annuler", role: .cancel) {}
            Button("Valider", role: .none) {
                account.name = newName
                account.isActive = newIsActive
                account.accountCategory = newCategory
                do {
                    try modelContext.save()
                    isEditing.toggle()
                } catch {
                    print("Erreur lors de la sauvegarde : \(error)")
                }
            }
        }, message: {
            Text("Êtes-vous sûr de vouloir valider les modifications ?")
        })
    }
}
struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
#Preview {
    let modelContainer = DataController.previewContainer
    let firstAccount = try! modelContainer.mainContext.fetch(FetchDescriptor<Account>()).first!
    return AccountDetailScreen(account: firstAccount)
        .environment(\.modelContext, modelContainer.mainContext)
        .environmentObject(DataController())
}
