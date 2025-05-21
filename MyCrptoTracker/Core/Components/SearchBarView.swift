//
//  SearchBarView.swift
//  MyCrptoTracker
//
//  Created by apple on 21/05/25.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText:String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(
                    searchText.isEmpty ? Color.theme.secondaryText : Color.theme.accent
                )
            
            TextField("Search by name or symbol..", text: $searchText)
                .foregroundStyle(Color.theme.accent)
                .autocorrectionDisabled()
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundStyle(Color.theme.accent)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchText = ""
                        }
                    , alignment: .trailing
                )
            
        }
        .font(.headline)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.theme.background)
                .shadow(
                    color: Color.theme.accent.opacity(0.15),
                    radius: 12,
                    x: 0,
                    y: 0
                )
        )
        .padding()

    }
}

#Preview {
    SearchBarView(searchText: .constant(""))
}
