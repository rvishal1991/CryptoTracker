//
//  SettingsView.swift
//  MyCrptoTracker
//
//  Created by apple on 30/05/25.
//

import SwiftUI
import SwiftfulRouting

struct SettingsView: View {
    
    @Environment(\.router) var router
    
    let defaultURL = URL(string: "https://www.google.com")!
    let youtubeURL = URL(string: "https://www.youtube.com")!
    let coingeckoUrl = URL(string: "https://www.coingecko.com/en/")!
    let personalUrl = URL(string: "https://github.com/rvishal1991/CryptoTracker")!

    var body: some View {
        NavigationView {
            List {
                youtubeLinkSection
                coinGeckoSection
                mySection
                applicationSection
            }
            .font(.headline)
            .tint(.blue)
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    XmarkButton()
                }
            }
        }
    }
        
}


#Preview {
    RouterView { _ in
        SettingsView()

    }
}

extension SettingsView {
    private var youtubeLinkSection: some View {
        Section(header: Text("My Crypto Tracker")) {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("This app was made to understand and explore SwiftUI. It uses MVVM architecture, Combine for data fetching, SwiftData for storing data and SwiftfulRouting for navigation.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            Link("YouTube", destination: youtubeURL)
        }
    }
    
    private var coinGeckoSection: some View {
        Section(header: Text("CoinGecko")) {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("The cryptocurrency data used in this app is provided by CoinGecko. It is free to use, but please note that I do not endorse or support any particular cryptocurrency or exchange.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Visit CoinGecko", destination: coingeckoUrl)
        }
    }
    
    private var mySection: some View {
        Section(header: Text("Vishal Rana")) {
            VStack(alignment: .leading) {
                Image("me")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                
                Text("It was developed as a learning project for SwiftUI. If you have any suggestions or want to contribute, please let me know!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            Link("Check out on Github", destination: personalUrl)
        }
    }
    
    private var applicationSection: some View {
        Section(header: Text("Application")) {
            Link("Terms of Service", destination: defaultURL)
            Link("Privacy Policy", destination: personalUrl)
            Link("Company Website", destination: personalUrl)
            Link("Learn More", destination: personalUrl)
        }
    }
}
