//
//  UIApplication.swift
//  MyCrptoTracker
//
//  Created by apple on 21/05/25.
//

import Foundation
import SwiftUI

extension UIApplication{
    
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
