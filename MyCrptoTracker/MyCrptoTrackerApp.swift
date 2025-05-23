//
//  MyCrptoTrackerApp.swift
//  MyCrptoTracker
//
//  Created by apple on 20/05/25.
//

import SwiftUI
import SwiftfulRouting
import SwiftData

@main
struct MyCrptoTrackerApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]

    }
    
    var body: some Scene {
        WindowGroup {
            RouterView { _ in
                HomeView()
                    .toolbarVisibility(.hidden, for: .navigationBar)
            }
            .environmentObject(vm)
        }
        .modelContainer(for:Portfolio.self) // The modelContainer holds the array of each Type of data that we want to read from the container
    }
}
