//
//  PortfolioDataService.swift
//  MyCrptoTracker
//
//  Created by apple on 23/05/25.
//

import Foundation
import SwiftData
import SwiftUI

class PortfolioDataService {
    
    private let modelContainer: ModelContainer?
    private let modelContext: ModelContext?

    @Published var savedPortfolios: [Portfolio] = []
   
    @MainActor
    init() {
        // Change isStoredInMemoryOnly to false if you would like to see the data persistance after kill/exit the app
        self.modelContainer = try? ModelContainer(for: Portfolio.self, configurations: ModelConfiguration(isStoredInMemoryOnly: false))
        self.modelContext = modelContainer?.mainContext
        self.getPortfolio()
        
    }
    
    // MARK: PUBLIC

    func updatePortfoilo(coin: Coin, amount:Double) {
        if let portfolio = savedPortfolios.first(where: { $0.coinID == coin.id }){
            if amount > 0{
                update(portfolio: portfolio, amount: amount)
            }else{
                remove(portfolio: portfolio)
            }
        }else {
            add(coin: coin, amount: amount)
        }
        
    }
    
    // MARK: PRIVATE
    
    private func getPortfolio() {
        do {
            savedPortfolios = try modelContext?.fetch(FetchDescriptor<Portfolio>()) ?? []
        } catch let error{
            print(error.localizedDescription)
        }
    }
    
    private func add(coin: Coin, amount:Double) {
        let portfolio = Portfolio(coinID: coin.id, amount: amount)
        modelContext?.insert(portfolio)
        applyChanges()
    }
    
    private func update(portfolio: Portfolio, amount:Double) {
        portfolio.amount = amount
        applyChanges()
    }
    
    private func remove(portfolio: Portfolio) {
        modelContext?.delete(portfolio)
        applyChanges()
    }
    
    private func save() {
        do {
            try modelContext?.save()
        } catch let error{
            print(error.localizedDescription)
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
}
