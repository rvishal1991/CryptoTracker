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
    @Published var isLoading: Bool = false
    @Published var sortType: SortType = .holdings

    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()

    @MainActor private let portfolioDataService = PortfolioDataService()
    
    private var cancellables: Set<AnyCancellable> = []
    
    enum SortType: String, CaseIterable {
        case rank
        case rankReveresed
        case holdings
        case holdingsReveresed
        case price
        case priceReveresed
    }
    
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
            .combineLatest(coinDataService.$allCoins, $sortType)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] coins in
                self?.allCoins = coins
            }
            .store(in: &cancellables)
        
        
        Task{
            await addSubscribersForPortfolio()
        }
        
        //updates market data
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] stats in
                self?.stats = stats
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func addSubscribersForPortfolio() {
        //updates portfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedPortfolios)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] coins in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: coins)
            }
            .store(in: &cancellables)
    }
    
    
    @MainActor
    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updatePortfoilo(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getMarketData()
        HapticManager.notification(type: .success)
    }
    
    private func filterAndSortCoins(text:String, coins: [Coin], sort:SortType) -> [Coin] {
        var updatedCoins = filterCoins(text:text, coins: coins)
        sortCoins(sort: sort, coins: &updatedCoins)
        return updatedCoins
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
    
    
    private func sortCoins(sort:SortType, coins: inout [Coin]) {
        switch sort {
        case .rank, .holdings:
            return coins.sort(by: {$0.rank < $1.rank})
            
        case .rankReveresed, .holdingsReveresed:
            return coins.sort(by: {$0.rank > $1.rank})
            
        case .price:
            return coins.sort(by: {$0.currentPrice > $1.currentPrice})

        case .priceReveresed:
            return coins.sort(by: {$0.currentPrice < $1.currentPrice})
         }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [Coin]) -> [Coin]{
       //will only sort by holdings or reversedholdings if needed
        switch sortType {
        case .holdings:
            return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingsReveresed:
            return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        default:
            return coins
        }
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins:[Coin], portfolioCoins:[Portfolio]) -> [Coin]{
        allCoins.compactMap { (coin) -> Coin? in
            guard let portfolio = portfolioCoins.first(where: { $0.coinID == coin.id }) else { return nil }
            return coin.updateHoldings(amount: portfolio.amount)
        }
    }
    
    private func mapGlobalMarketData(marketdata: MarketData?, portfolioCoins:[Coin]) -> [Statistics] {
        var stats: [Statistics] = []
        
        guard let data = marketdata else { return stats }
        
        let marketCap = Statistics(title: "Market Cap" , value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = Statistics(title: "24h Volume" , value: data.volume)
        let btcDominance = Statistics(title: "BTC Dominance" , value: data.btcDominance)
        
        let portfolioValue = portfolioCoins
            .map({$0.currentHoldingsValue })
            .reduce(0, +)
        
        let previousValue = portfolioCoins
            .map { (coin) -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = (coin.priceChangePercentage24H ?? 0)/100
                let previousValue = currentValue / (1 + percentChange)
                return previousValue
            }
            .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        let portfolio = Statistics(
            title: "Portfolio Value" ,
            value: portfolioValue.asCurrencyWith2Decimals(),
            percentageChange: percentageChange
        )
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        
        return stats
    }
    
}
