//
//  CollectionViewCell.swift
//  
//
//  Created by Reza Takhti on 1/4/20.
//

import UIKit

class CryptoCell: UICollectionViewCell {
    static let cellID = "cellID"
    
    override var isHighlighted: Bool{
        didSet {
            shrink(down: isHighlighted)
        }
    }
    
    let BGImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .center
        imageView.layer.contentsRect = CGRect(x: 0.0, y: 0.2, width: 1, height: 1)
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let darkOverlay : UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor(red: 212/255, green: 175/255, blue: 55/255, alpha: 1)
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.2
        return view
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.text = "$"
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "KohinoorTelugu-Medium", size: 25)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 50, weight: .heavy)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    public func set(networkData data: CurrencyModelNetwork){
        switch data.name{
        case "Bitcoin":
            BGImageView.image = #imageLiteral(resourceName: "Bitcoin")
        case "Ethereum":
            BGImageView.image = #imageLiteral(resourceName: "Ethereum")
        case "Litecoin":
            BGImageView.image = #imageLiteral(resourceName: "LiteCoin")
        case "XRP":
            BGImageView.image = #imageLiteral(resourceName: "Ripple")
        default:
            break
        }
        self.nameLabel.text = data.name
        self.priceLabel.text = "$" + String(data.marketData.currentPrice.usd)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shrink(down: Bool){
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.allowUserInteraction], animations: {
            if down {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            } else {
                self.transform = .identity
            }
        })
        
    }
    
    func setupConstraints(){
        addSubview(BGImageView)
        addSubview(darkOverlay)
        addSubview(priceLabel)
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            BGImageView.topAnchor.constraint(equalTo: topAnchor),
            BGImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            BGImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            BGImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            darkOverlay.topAnchor.constraint(equalTo: topAnchor),
            darkOverlay.bottomAnchor.constraint(equalTo: bottomAnchor),
            darkOverlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            darkOverlay.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: frame.height/15),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            priceLabel.heightAnchor.constraint(equalToConstant: 25),

        ])
    }
}
