//
//  DetailViewModel.swift
//  MyCrptoTracker
//
//  Created by apple on 29/05/25.
//

import Foundation
import Combine


class DetailViewModel:ObservableObject {
    
    @Published var overViewStatistics:[Statistics] = []
    @Published var additionalStatistics:[Statistics] = []
    @Published var coinDescription:String? = nil
    @Published var websiteURL:String? = nil
    @Published var redditURL:String? = nil

    @Published var coin:Coin
    private let coinDetailService: CoinDetailService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin:Coin) {
        self.coin = coin
        self.coinDetailService = CoinDetailService(coin: coin)
        self.addSubscribers()
    }
    
    
    private func addSubscribers() {
        
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] (returnedArrays) in
                self?.overViewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            }
            .store(in: &cancellables)
        
        coinDetailService.$coinDetails
            .sink { [weak self] (details) in
                self?.coinDescription = details?.readableDescription
                self?.websiteURL = details?.links?.homepage?.first
                self?.redditURL = details?.links?.subredditURL
            }
            .store(in: &cancellables)
        
    }
    
    private func mapDataToStatistics( coinDetail: CoinDetail?, coin: Coin) -> (overview: [Statistics], additional: [Statistics]){
        let overviewArray = createOverviewArray(coin: coin)
        let additionalArray = createAdditionalArray(coinDetail: coinDetail, coin: coin)
        return (overviewArray, additionalArray)
    }
    
    private func createOverviewArray(coin: Coin) -> [Statistics] {
        let price = coin.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = coin.priceChangePercentage24H
        let priceStat = Statistics(title: "Current Price", value: price, percentageChange: pricePercentChange)
        
        let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coin.marketCapChangePercentage24H
        let marketCapStat = Statistics(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentChange)
        
        let rank = "\(coin.rank)"
        let rankStat = Statistics(title: "Rank", value: rank)
        
        let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = Statistics(title: "Volume", value: volume)
        
        let overviewArray: [Statistics] = [
            priceStat, marketCapStat, rankStat, volumeStat
        ]
        return overviewArray
    }
    
    private func createAdditionalArray(coinDetail: CoinDetail?, coin: Coin) -> [Statistics] {
        
        let high = coin.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = Statistics(title: "24h High", value: high)
        
        let low = coin.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = Statistics(title: "24h Low", value: low)
        
        let priceChange = coin.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChange = coin.priceChangePercentage24H
        let priceChangeStat = Statistics(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange)
        
        let marketCapChange = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coin.marketCapChangePercentage24H
        let marketCapChangeStat = Statistics(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange)
        
        let blockTime = coinDetail?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = Statistics(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetail?.hashingAlgorithm ?? "n/a"
        let hashingStat = Statistics(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray: [Statistics] = [
            highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat
        ]
        return additionalArray
    }
}
