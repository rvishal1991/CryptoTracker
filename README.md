# 🪙 CryptoTracker

[![SwiftUI](https://img.shields.io/badge/SwiftUI-Compatible-orange.svg)](https://developer.apple.com/xcode/swiftui/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![iOS](https://img.shields.io/badge/iOS-15%2B-lightgrey.svg)]()

A modern cryptocurrency tracking app built using **SwiftUI**, leveraging **CoinGecko’s public API**, with a rich set of features including image caching, search, sorting, Core Data persistence, and chart visualization.

---

## 🚀 Features

- 📈 **Live Market Data** from [CoinGecko Open API](https://www.coingecko.com/en/api)
- 🌐 **Clean Networking Layer** using `URLSession`
- 🖼 **Image Caching** using `FileManager`
- 🧱 **MVVM Architecture** with modular, testable structure
- 🔄 **Combine Framework** for reactive data binding
- 🔍 **Custom Search** with real-time filtering
- ↕️ **Sorting** by price, name, and market cap
- 📊 **Custom Line Chart** for interactive price history
- 💾 **Swift Data** for portfolio storage
- 📱 **SwiftfulRouting**-based naviagtion flow
- ✨ **Custom Minor Animations** for smooth UX


---

## 🛠 Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/rvishal1991/CryptoTracker.git
   cd CryptoTracker

2. open CryptoTracker.xcodeproj

3. Run the app on Simulator or iOS device (iOS 15+ required)


## 📡 API
Data is powered by the public CoinGecko API:

/coins/markets – fetch market data

/coins/{id} – fetch details and historical data

⚠️ No API key is required. Subject to rate limits.



