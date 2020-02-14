//
//  Double+Ext.swift
//  CurrencyTracker
//
//  Created by Reza Takhti on 2/13/20.
//  Copyright © 2020 Reza Takhti. All rights reserved.
//

import Foundation

extension Double {
    func percentFormatted() -> String{
        let percentFormatter = NumberFormatter()
        percentFormatter.numberStyle = NumberFormatter.Style.percent
        percentFormatter.multiplier = 1
        percentFormatter.minimumFractionDigits = 1
        percentFormatter.maximumFractionDigits = 2
        return percentFormatter.string(for: self) ?? ""
    }
}
