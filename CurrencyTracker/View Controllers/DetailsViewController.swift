//
//  DetailsViewController.swift
//  CurrencyTracker
//
//  Created by Reza Takhti on 1/18/20.
//  Copyright © 2020 Reza Takhti. All rights reserved.
//

import UIKit

class DetailsViewController : UIViewController {
    lazy var exitButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "CancelButton").withRenderingMode(.alwaysOriginal), for: .normal)
        button.backgroundColor = .bitcoin()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(exitButtonPressed), for: .touchUpInside)
        return button
    }()
    private var amount : Double?
    private var percentage : Double?
    private var animationStartDate = Date()
    
    var selectedCurrency : CurrencyModelNetwork?
    let logoView = LogoView()
    let cardView = CardView()
    let graphVC = GraphChildViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureGraphChildVC()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLogoView()
        animationStartDate = Date()
        graphVC.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        graphVC.delegate = nil
    }
    
    @objc private func exitButtonPressed(){
        dismiss(animated: true, completion: nil)
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
        view.addSubview(cardView)
        view.addSubview(exitButton)
        
        logoView.set(logoImage: #imageLiteral(resourceName: "BitcoinBG"), title: CurrencyEnums.Bitcoin.rawValue)
        logoView.titleLabel.text = selectedCurrency?.name
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (UIScreen.main.bounds.height * 0.1) + 32),
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
    
    private func setupLogoView(){
        view.addSubview(logoView)
        view.sendSubviewToBack(logoView)
        let topConstraint = logoView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16)
        
        NSLayoutConstraint.activate([
            logoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            topConstraint,
            logoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            logoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
        ])
        
        view.layoutIfNeeded()
        view.superview?.layoutIfNeeded()
        
        topConstraint.isActive = false
        logoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true

        
        UIView.animate(withDuration: 0.5, delay: 0.25, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            self.view.superview?.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension DetailsViewController : GraphViewDelegate {
    func calculatedPercentChange(value: Double) {
        let decreaseImage = #imageLiteral(resourceName: "DecreaseArrow")
        let increaseImage = #imageLiteral(resourceName: "IncreaseArrow")
        cardView.arrowImageView.image = value > 0 ? increaseImage : decreaseImage
        percentage = value
        cardView.percentIncreaseLabel.text =  value.percentFormatted()
    }
    
    func amountLabelShouldChange(value: Double) {
        amount = value
        cardView.amountLabel.text = String(format: "$%.02f", value)
    }
    
    func animateLabels(){
        let displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
        displayLink.add(to: .main, forMode: .default)
    }
    
    @objc private func handleUpdate(){
        guard let amount = amount, let percentage = percentage else { return }
        
        let animationDuration: Double = 1
        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStartDate)
        
        if elapsedTime > animationDuration {
            cardView.amountLabel.text = String(format: "$%.02f", amount)
            cardView.percentIncreaseLabel.text = percentage.percentFormatted()
        } else {
            let percentageComplete = elapsedTime / animationDuration
            let percentValue = percentageComplete * percentage
            let amount = percentageComplete * amount
            cardView.amountLabel.text = String(format: "$%.02f", amount)
            cardView.percentIncreaseLabel.text = percentValue.percentFormatted()
        }
    }
    
  
}


