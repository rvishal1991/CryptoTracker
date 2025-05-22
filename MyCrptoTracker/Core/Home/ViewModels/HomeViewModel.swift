//
//  HomeViewModel.swift
//  MyCrptoTracker
//
//  Created by apple on 21/05/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var stats: [Statistics] = []
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var searchText:String = ""
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()

    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        addSubscribers()
    }
    
    
    func addSubscribers() {
//        dataService.$allCoins
//            .sink { [weak self] coins in
//                self?.allCoins = coins
//            }
//            .store(in: &cancellables)
       
        //updates allcoins
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] coins in
                self?.allCoins = coins
            }
            .store(in: &cancellables)
        
        //updates market data
        marketDataService.$marketData
            .map(mapGlobalMarketData)
            .sink { [weak self] stats in
                self?.stats = stats
            }
            .store(in: &cancellables)
    }
    
    private func filterCoins(text:String, coins: [Coin]) -> [Coin] {
        guard !text.isEmpty else {
            return coins
        }
        let loweredText = text.lowercased()
        return coins.filter{
            $0.name.lowercased().contains(loweredText) || $0.symbol.lowercased().contains(loweredText) ||
            $0.id.lowercased().contains(loweredText)
        }
    }
    
    private func mapGlobalMarketData(marketdata: MarketData?) -> [Statistics] {
        var stats: [Statistics] = []
        
        guard let data = marketdata else { return stats }
        
        let marketCap = Statistics(title: "Market Cap" , value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = Statistics(title: "24h Volume" , value: data.volume)
        let btcDominance = Statistics(title: "BTC Dominance" , value: data.btcDominance)
        let portfolio = Statistics(title: "Portfolio Value" , value: "$0.00", percentageChange: 0)

        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])

        return stats
    }
    
}
