//
//  UIView+Ext.swift
//  CurrencyTracker
//
//  Created by Reza Takhti on 2/13/20.
//  Copyright © 2020 Reza Takhti. All rights reserved.
//

import UIKit

fileprivate let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))

extension UIView {
    func addIndicator(){
        addSubview(indicator)
        indicator.style = .large
        indicator.color = .white
        indicator.center = center
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
    }
    
    func removeIndicator(){
        indicator.stopAnimating()
        indicator.removeFromSuperview()
        
    }
}
