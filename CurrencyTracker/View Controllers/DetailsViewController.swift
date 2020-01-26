//
//  DetailsViewController.swift
//  CurrencyTracker
//
//  Created by Reza Takhti on 1/18/20.
//  Copyright © 2020 Reza Takhti. All rights reserved.
//

import UIKit

class DetailsViewController : UIViewController {
    
    var currency = CurrencyModelNetwork(name: "", price: 0)
    var logoImageView : UIImageView = {
        let iv = UIImageView(image: nil)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let priceLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "KohinoorTelugu-Medium", size: 40)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNetworkCalls()
        setupConstraints()
        view.backgroundColor = .white
    }
    
    private func setupConstraints(){
        view.addSubview(priceLabel)
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            priceLabel.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            priceLabel.heightAnchor.constraint(equalToConstant: 50),
            
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logoImageView.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -32),
            logoImageView.heightAnchor.constraint(equalToConstant: 90),
        
        ])
    }
    
    private func makeNetworkCalls(){
        let currencyStrings = ["bitcoin", "ethereum", "ripple", "litecoin"]
        var currencyName = ""
        switch title {
        case CurrencyEnums.Bitcoin.rawValue:
             currencyName = currencyStrings[0]
        case CurrencyEnums.Litecoin.rawValue:
             currencyName = currencyStrings[3]
        case CurrencyEnums.XRP.rawValue:
             currencyName = currencyStrings[2]
        case CurrencyEnums.Ethereum.rawValue:
             currencyName = currencyStrings[1]
        default: break
        }
        
        NetworkManager.shared.getPrice(for: currencyName) { [weak self](root, error) in
            guard let self = self else { return }
            guard let root = root else {
                print(error)
                return
            }
            print(root.name)
            
            self.currency = CurrencyModelNetwork(name: root.name, price: root.marketData.currentPrice.usd)
            DispatchQueue.main.async {
            self.priceLabel.text = "$" + String(self.currency.marketData.currentPrice.usd)
            }
            
            
        }
    }
}

extension DetailsViewController : DetailedViewDelegate {
    func didSendLogoImage(logoImage: UIImage) {
        self.logoImageView.image = logoImage
    }
}
