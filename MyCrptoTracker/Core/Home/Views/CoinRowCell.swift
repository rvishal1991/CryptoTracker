//
//  CoinRowCell.swift
//  MyCrptoTracker
//
//  Created by apple on 21/05/25.
//

import SwiftUI

struct CoinRowCell: View {
    
    var coin:Coin = .mock
    var showHoldingsColumn:Bool = true
    var onTap: (() -> Void)? = nil
    var body: some View {
        HStack(spacing : 0) {
            leftColumn
            Spacer()
            if showHoldingsColumn{
                centerColumn
            }
            rightColumn
        }
        .font(.subheadline)
        .background(
            Color.theme.background
                .opacity(0.001)
        )
        .onTapGesture {
            onTap?()
        }
    }
}


#Preview(traits: .sizeThatFitsLayout) {
    Group {
        CoinRowCell(showHoldingsColumn: false)
        CoinRowCell(showHoldingsColumn: true)
    }
}


extension CoinRowCell {
    
    private var leftColumn: some View {
        HStack(spacing : 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
                .frame(minWidth: 30)
            
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundStyle(Color.theme.accent)
        }
    }
    
    
    private var centerColumn: some View {
        
        VStack(alignment: .trailing) {
            Text("\(coin.currentHoldingsValue.asCurrencyWith6Decimals())")
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString() )
        }
        .foregroundStyle(Color.theme.accent)
    }
    
    private var rightColumn: some View {
        
        VStack(alignment: .trailing) {
            Text("\(coin.currentPrice.asCurrencyWith2Decimals())")
                .bold()
                .foregroundStyle(Color.theme.accent)
            
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundStyle((coin.priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}
