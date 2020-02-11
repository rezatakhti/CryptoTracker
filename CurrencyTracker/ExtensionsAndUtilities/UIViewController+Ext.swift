//
//  UIViewController+Ext.swift
//  CurrencyTracker
//
//  Created by Reza Takhti on 1/25/20.
//  Copyright © 2020 Reza Takhti. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func createActivityIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.hidesWhenStopped = true
        return indicator
    }
    
}

fileprivate var stackView : UIStackView!

extension UIView {
    func createDateStackView() -> UIStackView {
        let dateLabelsArray = ["1D", "1W", "1M", "3M", "6M", "1Y"]
        
        var buttons = [UIButton]()
               
               for label in dateLabelsArray {
                   let button = UIButton()
                   button.setTitle(label, for: .normal)
                   button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
                   button.setTitleColor(.white, for: .normal)
                   button.translatesAutoresizingMaskIntoConstraints = false
                   button.widthAnchor.constraint(equalTo: button.heightAnchor).isActive = true
                   
                   buttons.append(button)
               }
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let button = stackView.arrangedSubviews.first!
        button.backgroundColor = UIColor(white: 1, alpha: 0.3)
        
        return stackView
    }



}


