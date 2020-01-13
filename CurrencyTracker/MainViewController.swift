//
//  ViewController.swift
//  CurrencyTracker
//
//  Created by Reza Takhti on 12/31/19.
//  Copyright © 2019 Reza Takhti. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var currencies = [CurrencyModel]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        print("is this being called")
        return .lightContent
    }
    
    private var indexOfCellBeforeDragging = 0
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 25
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.contentInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        cv.showsHorizontalScrollIndicator = false
        cv.decelerationRate = .fast
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.register(CryptoCell.self, forCellWithReuseIdentifier: CryptoCell.cellID)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        makeNetworkCalls()
        setupView()
        setupCollectionView()
        
        self.collectionView.reloadData()
    }
    
    private func makeNetworkCalls(){
        let currencyStrings = ["bitcoin", "ethereum", "ripple", "litecoin"]
        currencyStrings.forEach { (currencyName) in
            NetworkManager.shared.getPrice(for: currencyName) { (root, error) in
                guard let root = root else {
                    print(error)
                    return
                }
                let currency = CurrencyModel(name: root.name, price: root.marketData.currentPrice.usd)
                self.currencies.append(currency)
                print("success")
            }
        }
    }
    
    
    func setupCollectionView(){
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height/6),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height/7),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
    }

    func setupView(){
        navigationItem.title = "CryptoTracker"
        
        view.backgroundColor = .white
    }
}

extension MainViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CryptoCell.cellID, for: indexPath) as! CryptoCell
        if currencies.count == 4 {
            cell.nameLabel.text = currencies[indexPath.item].name
            cell.priceLabel.text = String(currencies[indexPath.item].marketData.currentPrice.usd)
        }
        return cell
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionView.scrollToNearestVisibleCollectionViewCell()
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        collectionView.scrollToNearestVisibleCollectionViewCell()
    }
}

extension MainViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - view.frame.width / 3
        return CGSize(width: width , height: collectionView.frame.height)
    }
    
}


