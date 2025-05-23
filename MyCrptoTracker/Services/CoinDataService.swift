//
//  CoinDataService.swift
//  MyCrptoTracker
//
//  Created by apple on 21/05/25.
//

import Foundation
import Combine

class CoinDataService{
    
    @Published  var allCoins: [Coin] = []
    var coinSubscription:AnyCancellable?
    
    init() {
        getCoins()
    }
    
    func getCoins() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return  }
        
        coinSubscription =  NetworkingManager.download(url: url)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] coins in
                self?.allCoins = coins
                self?.coinSubscription?.cancel() // only want to fetch one time so after getting coins cancelling
            })
    }
    
    private func loadCoins()  async throws -> [Coin] {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else {
            throw URLError(.badURL)  }
        
        let (data, _ ) =  try await URLSession.shared.data(from: url)
        let coins = try JSONDecoder().decode([Coin].self, from: data)
        return coins
    }
}

