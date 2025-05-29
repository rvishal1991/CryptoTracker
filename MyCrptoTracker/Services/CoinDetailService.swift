//
//  CoinDetailService.swift
//  MyCrptoTracker
//
//  Created by apple on 29/05/25.
//

import Foundation

import Combine

class CoinDetailService{
    
    @Published var coinDetails: CoinDetail? = nil
    var coinDetailSubscription:AnyCancellable?
    
    let coin:Coin
    
    init(coin:Coin) {
        self.coin = coin
        getCoinDetails()
    }
    
    func getCoinDetails() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return  }
        
        coinDetailSubscription =  NetworkingManager.download(url: url)
            .decode(type: CoinDetail.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] detail in
                self?.coinDetails = detail
                self?.coinDetailSubscription?.cancel() // only want to fetch one time so after getting coins cancelling
            })
    }

}

