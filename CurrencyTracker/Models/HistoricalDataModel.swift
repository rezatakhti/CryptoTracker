//
//  HistoricalDataModel.swift
//  CurrencyTracker
//
//  Created by Reza Takhti on 2/13/20.
//  Copyright © 2020 Reza Takhti. All rights reserved.
//

import UIKit

struct HistoricalData: Codable {
    let prices : [Price]
}

struct Price: Codable{
    let time: Int
    let price: Double
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        time = try container.decode(Int.self)
        price = try container.decode(Double.self)
    }
}
