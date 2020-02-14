//
//  LogoView.swift
//  CurrencyTracker
//
//  Created by Reza Takhti on 2/8/20.
//  Copyright © 2020 Reza Takhti. All rights reserved.
//

import UIKit

class LogoView : UIView {
    
    let logoImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 45, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func layoutSubviews() {
        let shadowLayer = CAShapeLayer()
        
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 25).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        shadowLayer.shadowOpacity = 0.1
        shadowLayer.shadowRadius = 10
        
        
        layer.insertSublayer(shadowLayer, at: 0)
        
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        backgroundColor = .white
        

        translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
    
    private func setupConstraints(){
        addSubview(logoImage)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            logoImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            logoImage.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            logoImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            logoImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/4),
            
            titleLabel.leadingAnchor.constraint(equalTo: logoImage.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    func set(logoImage image: UIImage, title: String){
        logoImage.image = image
        titleLabel.text = title
        
        switch title {
        case CurrencyEnums.Bitcoin.rawValue:
            titleLabel.textColor = .bitcoin()
        default:
            break;
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
