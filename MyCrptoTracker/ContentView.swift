//
//  ContentView.swift
//  MyCrptoTracker
//
//  Created by apple on 20/05/25.
//

import SwiftUI
import SwiftfulRouting

struct ContentView: View {
    var body: some View {
        ZStack{
            Color.theme.background.ignoresSafeArea()
            
            VStack(spacing: 40){
                Text("Accent Color")
                    .foregroundStyle(Color.theme.accent)
                
                Text("Secondary Text Color")
                    .foregroundStyle(Color.theme.secondaryText)

                
                Text("Red Color")
                    .foregroundStyle(Color.theme.red)


                Text("Green Color")
                    .foregroundStyle(Color.theme.green)

            }
            .font(.headline)
        }
    }
}

#Preview {
    RouterView { _ in
        ContentView()
    }
}
