//
//  MyCrptoTrackerApp.swift
//  MyCrptoTracker
//
//  Created by apple on 20/05/25.
//

import SwiftUI

@main
struct MyCrptoTrackerApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .toolbarVisibility(.hidden, for: .navigationBar)
            }
            .environmentObject(vm)
        }
    }
}
