//
//  CollectionViewCell.swift
//  
//
//  Created by Reza Takhti on 1/4/20.
//

import UIKit

class CryptoCell: UICollectionViewCell {
    static let cellID = "cellID"
    
    let logoImageView : UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "bitcoinLogo"))
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let BGImageView : UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "BitcoinBG"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.text = "$"
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "KohinoorTelugu-Medium", size: 40)
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
        setupConstraints()
    }
    
    public func set(withAssets assets: CurrencyModelAssets, networkData data: CurrencyModelNetwork){
        self.logoImageView.image = assets.logoIMage
        self.BGImageView.image = assets.bgImage
        
        self.nameLabel.text = data.name
        self.priceLabel.text = "$" + String(data.marketData.currentPrice.usd)
        
        if self.nameLabel.text == "XRP" {
            priceLabel.textColor = .black
        } else {
            priceLabel.textColor = .white
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints(){
        addSubview(BGImageView)
        addSubview(priceLabel)
        addSubview(nameLabel)
        addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            BGImageView.topAnchor.constraint(equalTo: topAnchor),
            BGImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            BGImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            BGImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: topAnchor, constant: frame.height/10),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            priceLabel.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -frame.height/10),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            nameLabel.heightAnchor.constraint(equalToConstant: frame.height/3),
            
            logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: frame.height/8),
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            logoImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            logoImageView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
        ])
    }
}
