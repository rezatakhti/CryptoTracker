//
//  CollectionViewCell.swift
//  
//
//  Created by Reza Takhti on 1/4/20.
//

import UIKit

class CryptoCell: UICollectionViewCell {
    static let cellID = "cellID"
    
    let BGimageView : UIImageView = {
        let image = #imageLiteral(resourceName: "CryptoCellBG")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.text = "$28"
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 80, weight: .heavy)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Bitcoin"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 50, weight: .light)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constraintImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constraintImageView(){
        addSubview(BGimageView)
        addSubview(priceLabel)
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            BGimageView.topAnchor.constraint(equalTo: topAnchor),
            BGimageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            BGimageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            BGimageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            priceLabel.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            nameLabel.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}
