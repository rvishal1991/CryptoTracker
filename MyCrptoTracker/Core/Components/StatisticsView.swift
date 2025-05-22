//
//  StatisticsView.swift
//  MyCrptoTracker
//
//  Created by apple on 22/05/25.
//

import SwiftUI

struct StatisticsView: View {
    
    var state:Statistics = .mock
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(state.title)
                .font(.caption)
                .foregroundStyle(Color.theme.secondaryText)
            Text(state.value)
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
            
            HStack(spacing: 4){
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees: (state.percentageChange ?? 0) >= 0 ? 0 : 180)
                    )
                
                Text(state.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle((state.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(state.percentageChange == nil ? 0.0 : 1.0)
           
        }
    }
}

#Preview {
    StatisticsView()
}
