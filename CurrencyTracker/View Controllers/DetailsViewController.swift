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
    lazy var exitButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "CancelButton").withRenderingMode(.alwaysOriginal), for: .normal)
        button.backgroundColor = .bitcoin()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let logoView = LogoView()
    let cardView = CardView()
    let graphVC = GraphChildViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // makeNetworkCalls()
        
        setupViews()
        configureGraphChildVC()
        view.backgroundColor = .white
    }
    
    private func configureGraphChildVC(){
        view.addSubview(graphVC.view)
        addChild(graphVC)
        graphVC.didMove(toParent: self)
        setupGraphVCConstraints()
    }
    
    private func setupGraphVCConstraints(){
        graphVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            graphVC.view.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            graphVC.view.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            graphVC.view.heightAnchor.constraint(equalTo: cardView.heightAnchor, multiplier: 0.5),
            graphVC.view.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
        ])
        
    }
    
    private func setupViews(){
        view.addSubview(logoView)
        view.addSubview(cardView)
        view.addSubview(exitButton)
        
        logoView.set(logoImage: #imageLiteral(resourceName: "BitcoinBG"), title: CurrencyEnums.Bitcoin.rawValue)
        
        NSLayoutConstraint.activate([
            logoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            logoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            logoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            
            cardView.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 16),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cardView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            
            exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            exitButton.widthAnchor.constraint(equalToConstant: 45),
            exitButton.heightAnchor.constraint(equalTo: exitButton.widthAnchor),
            
        ])
        
        self.view.layoutIfNeeded()
        exitButton.layer.cornerRadius = 0.5 * exitButton.frame.width
        exitButton.layer.masksToBounds = true
        
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
               // self.priceLabel.text = "$" + String(self.currency.marketData.currentPrice.usd)
            }
            
            
        }
    }
}

extension DetailsViewController : DetailedViewDelegate {
    func didSendLogoImage(logoImage: UIImage) {
        //self.logoImageView.image = logoImage
    }
}


