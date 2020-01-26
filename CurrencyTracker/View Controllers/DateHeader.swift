//
//  DateHeader.swift
//  CurrencyTracker
//
//  Created by Reza Takhti on 1/25/20.
//  Copyright © 2020 Reza Takhti. All rights reserved.
//

import UIKit

class DateHeader: UICollectionReusableView {
    static let identifier = "headerID"
    
    let todayLabel: UILabel = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let dateString = formatter.string(from: Date())
        let label = UILabel()
        label.text = dateString
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupLabel()
    }
    
    func setupLabel(){
        addSubview(todayLabel)
        
        NSLayoutConstraint.activate([
            todayLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            todayLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            todayLabel.heightAnchor.constraint(equalToConstant: 50),
            todayLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
