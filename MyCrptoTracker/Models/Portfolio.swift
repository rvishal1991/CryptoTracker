//
//  Item.swift
//  MyCrptoTracker
//
//  Created by apple on 23/05/25.
//

import SwiftUI
import SwiftData


// Adding @Model here tells SwiftData that this will be a table in our database
@Model
class Portfolio {
    var coinID: String
    var amount: Double
    
    init(coinID: String, amount: Double) {
        self.coinID = coinID
        self.amount = amount
    }
}
