//
//  Statistics.swift
//  MyCrptoTracker
//
//  Created by apple on 22/05/25.
//

import Foundation

struct Statistics: Identifiable {
   
    var id = UUID().uuidString
    var title:String = ""
    var value:String = ""
    var percentageChange:Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
    
    static var mock: Statistics {
        Statistics(title: "Market Cap", value: "$12.5Bn", percentageChange: 23.45)
    }
    
}

