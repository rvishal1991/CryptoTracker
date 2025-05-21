//
//  CircleButtonView.swift
//  MyCrptoTracker
//
//  Created by apple on 20/05/25.
//

import SwiftUI

struct CircleButtonView: View {
    
    var iconName:String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundStyle(Color.theme.accent)
            .frame(width: 48, height: 48)
            .background(
                Circle()
                    .foregroundStyle(Color.theme.background)
            )
            .shadow(
                color: Color.theme.accent.opacity(0.25),
                radius: 10,
                x: 0,
                y: 0
            )
            .padding()
    }
}

#Preview(traits: .sizeThatFitsLayout) {

    Group{
        CircleButtonView(iconName: "info")
            .padding()
        
        CircleButtonView(iconName: "plus")
            .padding()
            .colorScheme(.dark)
    }
    
}
