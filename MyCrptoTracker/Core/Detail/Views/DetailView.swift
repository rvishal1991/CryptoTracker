//
//  DetailView.swift
//  MyCrptoTracker
//
//  Created by apple on 23/05/25.
//

import SwiftUI
import SwiftfulRouting

struct DetailView: View {
    @Environment(\.router) var router

    var coin:Coin = .mock
    
    var body: some View {
        Text(coin.name)
    }
}

#Preview {
    RouterView { _ in
        DetailView()
    }
}
