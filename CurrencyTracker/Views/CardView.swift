//
//  CardView.swift
//  CurrencyTracker
//
//  Created by Reza Takhti on 2/8/20.
//  Copyright © 2020 Reza Takhti. All rights reserved.
//

import UIKit

class CardView : UIView {
    
    let amountLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 35, weight: .medium)
        return label
    }()
    
    let percentIncreaseLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)

        return label
    }()
    
    let arrowImageView : UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "IncreaseArrow"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    
    var stackView : UIStackView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        createDateButtons()
    }
    
    private func createDateButtons(){
        stackView = createDateStackView()
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75),
            stackView.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        layoutIfNeeded()
        
        for button in stackView.arrangedSubviews {
            button.layer.cornerRadius = button.frame.width * 0.5
            button.layer.masksToBounds = true
            (button as! UIButton).addTarget(self, action: #selector(changeSelection), for: .touchUpInside)
        }
    }
    
    @objc private func changeSelection(button: UIButton){
        guard let stackView = stackView else { return }
        
        let buttonDict = ["buttonLabel" : button.titleLabel!.text]
        
        NotificationCenter.default.post(Notification(name: .didPressDateButton, object: nil, userInfo: buttonDict as [AnyHashable : Any]))
        
        for button in stackView.arrangedSubviews{
            button.backgroundColor = .clear
        }

        button.backgroundColor = UIColor(white: 1, alpha: 0.3)
    }
    
    private func setupConstraints(){
        addSubview(amountLabel)
        addSubview(percentIncreaseLabel)
        addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            amountLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            amountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            amountLabel.heightAnchor.constraint(equalToConstant: 30),
            
            percentIncreaseLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 16),
            percentIncreaseLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            percentIncreaseLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            percentIncreaseLabel.heightAnchor.constraint(equalToConstant: 20),
            
            arrowImageView.trailingAnchor.constraint(equalTo: percentIncreaseLabel.leadingAnchor),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20),
            arrowImageView.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 16),
            arrowImageView.widthAnchor.constraint(equalToConstant: 20),
            
        ])
    }
    
    private func setupView(){

        backgroundColor = .bitcoin()
        layer.cornerRadius = 15
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
