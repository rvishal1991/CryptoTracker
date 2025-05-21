//
//  HomeViewModel.swift
//  MyCrptoTracker
//
//  Created by apple on 21/05/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var searchText:String = ""
    
    private let dataService = CoinDataService()
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
            .combineLatest(dataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] coins in
                self?.allCoins = coins
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
    
}
