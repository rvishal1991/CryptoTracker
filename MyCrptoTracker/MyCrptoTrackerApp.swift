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
    @State private var showLaunchView: Bool = true
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]

    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                RouterView { _ in
                    HomeView()
                        .toolbarVisibility(.hidden, for: .navigationBar)
                }
                .environmentObject(vm)
                
                ZStack{
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
        }
        .modelContainer(for:Portfolio.self) // The modelContainer holds the array of each Type of data that we want to read from the container
    }
}
