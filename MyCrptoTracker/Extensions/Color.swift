//
//  Color.swift
//  MyCrptoTracker
//
//  Created by apple on 20/05/25.
//

import SwiftUI
import Foundation

extension Color{
    
    static let theme = ColorTheme()
    static let launch = LaunchTheme()

}


struct ColorTheme{
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreeenColor")
    let red = Color("ReedColor")
    let secondaryText = Color("SecondaryTextColor")

}

struct LaunchTheme{
    let accent = Color("LaunchAccentColor")
    let background = Color("LaunchBackgroundColor")
}

