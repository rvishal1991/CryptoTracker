//
//  ChartView.swift
//  MyCrptoTracker
//
//  Created by apple on 29/05/25.
//

import SwiftUI
import Charts

struct nChartView: View {
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date
    @State private var percentage: CGFloat = 0
    
    init(coin:Coin) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
       
        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60)
    }
    
    var body: some View {
        
        VStack {
            Chart(0..<data.count, id: \.self){ index in
                LineMark(
                    x: .value("X values", index),
                    y: .value("Y values", data[index])
                )
                .interpolationMethod(.linear)
                .foregroundStyle(lineColor)
                .lineStyle(.init(lineWidth: 2, lineCap: .round, lineJoin: .round))
            }
            .animation(.linear, value: percentage)
            .chartXScale(domain: minY...maxY)
            .chartXAxis {
                AxisMarks(stroke: StrokeStyle(lineWidth: 0))
            }
            .chartYAxis {
                AxisMarks(stroke: StrokeStyle(lineWidth: 0))
            }
            .frame(height: 200)
            .overlay(chartYAxis.padding(.horizontal, 4), alignment: .leading)
            
            chartDateLabels
                .padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        
        
    }
}

#Preview {
    nChartView(coin: .mock)
}


extension nChartView{
    
    private var chartYAxis: some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY + minY) / 2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    
    private var chartDateLabels: some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
    
}
