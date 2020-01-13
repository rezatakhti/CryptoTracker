//
//  SpotPrice.swift
//  CurrencyTracker
//
//  Created by Reza Takhti on 1/8/20.
//  Copyright © 2020 Reza Takhti. All rights reserved.
//

import Foundation

struct CurrencyModel: Codable{
    var name: String
    var marketData : MarketData
    
    enum CodingKeys : String, CodingKey {
        case name
        case marketData = "market_data"
    }
    
    init(name: String, price: Double){
        self.name = name
        marketData = MarketData(price)
    }
}

struct MarketData : Codable{
    var currentPrice : CurrentPrice
    
    enum CodingKeys : String, CodingKey {
        case currentPrice = "current_price"
    }
    
    init(_ price: Double){
        currentPrice = CurrentPrice(price)
    }
}

struct CurrentPrice : Codable{
    var usd : Double
    
    init(_ price: Double){
        usd = price
    }
}
