//
//  CollectionViewCell.swift
//  
//
//  Created by Reza Takhti on 1/4/20.
//

import UIKit

class CryptoCell: UICollectionViewCell {
    
    let BGimageView : UIImageView = {
        let image = #imageLiteral(resourceName: "CryptoCellBG")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        
        NSLayoutConstraint.activate([
            BGimageView.topAnchor.constraint(equalTo: topAnchor),
            BGimageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            BGimageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            BGimageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
