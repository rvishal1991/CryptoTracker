//
//  MarketDataService.swift
//  MyCrptoTracker
//
//  Created by apple on 22/05/25.
//

import Foundation
import Combine
class MarketDataService{
    
    @Published  var marketData: MarketData? = nil
    var marketDataSubscription:AnyCancellable?
    
    init() {
        getMarketData()
    }
    
    func getMarketData() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return  }
        
        marketDataSubscription =  NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] globalData in
                self?.marketData = globalData.data
                self?.marketDataSubscription?.cancel() 
            })
    }
    
  
}
