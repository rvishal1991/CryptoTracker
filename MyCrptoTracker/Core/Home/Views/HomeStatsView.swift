//
//  HomeStatsView.swift
//  MyCrptoTracker
//
//  Created by apple on 22/05/25.
//

import SwiftUI

struct HomeStatsView: View {
    
    @EnvironmentObject private var vm:HomeViewModel
    @Binding var showPortfolio: Bool
    
    var body: some View {
        
        HStack {
            ForEach(vm.stats ){ stat in
                StatisticsView(state: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .trailing : .leading)

    }
}

#Preview {
    HomeStatsView(showPortfolio: .constant(false))
        .environmentObject(HomeViewModel())
}
