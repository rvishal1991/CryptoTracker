//
//  HomeView.swift
//  MyCrptoTracker
//
//  Created by apple on 20/05/25.
//

import SwiftUI
import SwiftfulRouting

struct HomeView: View {
    
    @Environment(\.router) var router
   
    @EnvironmentObject private var vm:HomeViewModel
    @State private var showPortfolio:Bool = false // animate right
    @State private var selectedCoin:Coin? = nil
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack {
                homeHeader
                HomeStatsView(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $vm.searchText)
                columnTitles
                
                if !showPortfolio {
                    allCoinsList
                        .transition(.move(edge: .leading))
                }
                
                if showPortfolio {
                    portfolioCoinsList
                        .transition(.move(edge: .trailing))
                }
               
                Spacer(minLength: 0)
            }
        }
        
    }
}

#Preview {
    RouterView { _ in
        HomeView()
            .toolbarVisibility(.hidden, for: .navigationBar)
    }
    .environmentObject(HomeViewModel())
}


extension HomeView {
    
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none, value: showPortfolio)
                .onTapGesture {
                    if showPortfolio{
                        router.showScreen(.sheet) { _ in
                            PortfolioView()
                                .environmentObject(vm)
                        }
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.theme.accent)
                .animation(.none, value: showPortfolio)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowCell(coin: coin, showHoldingsColumn: false, onTap: {
                    selectedCoin = coin
                    router.showScreen(.push) { _ in
                        DetailView(coin: coin)
                    }
                })
                .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                .listRowBackground(Color.theme.background)
            }
        }
        .listStyle(.plain)
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowCell(coin: coin, showHoldingsColumn: true, onTap: {
                    selectedCoin = coin
                    router.showScreen(.push) { _ in
                        DetailView(coin: coin)
                    }
                })
                .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                .listRowBackground(Color.theme.background)
            }
        }
        .listStyle(.plain)
    }
    
    private var columnTitles: some View {
        HStack {
            
            HStack (spacing: 4){
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity( (vm.sortType == .rank || vm.sortType == .rankReveresed ) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortType == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortType = vm.sortType == .rank ? .rankReveresed : .rank
                }
            }
            
            Spacer()
            if showPortfolio {
                HStack (spacing: 4){
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortType == .holdings || vm.sortType == .holdingsReveresed ) ? 1.0 : 0.0 )
                        .rotationEffect(Angle(degrees: vm.sortType == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        vm.sortType = vm.sortType == .holdings ? .holdingsReveresed : .holdings
                    }
                }
            }
            
            HStack (spacing: 4){
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortType == .price || vm.sortType == .priceReveresed ) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortType == .price ? 0 : 180))

            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortType = vm.sortType == .price ? .priceReveresed : .price
                }
            }
            
            Button {
                withAnimation(.linear(duration: 2.0)) {
                    vm.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)

        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}
