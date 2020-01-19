//
//  ViewController.swift
//  CurrencyTracker
//
//  Created by Reza Takhti on 12/31/19.
//  Copyright © 2019 Reza Takhti. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var currencies : Array<CurrencyModelNetwork> = Array(repeating: CurrencyModelNetwork(name: "", price: 0), count: 4)
    var imageAssets = [
        CurrencyModelAssets(bgImage: #imageLiteral(resourceName: "BitcoinBG"), logoIMage: #imageLiteral(resourceName: "bitcoinLogo")),
        CurrencyModelAssets(bgImage: #imageLiteral(resourceName: "LitecoinBG"), logoIMage: #imageLiteral(resourceName: "LitecoinLogo")),
        CurrencyModelAssets(bgImage: #imageLiteral(resourceName: "RippleBG"), logoIMage: #imageLiteral(resourceName: "RippleLoGO")),
        CurrencyModelAssets(bgImage: #imageLiteral(resourceName: "EthereumBG"), logoIMage: #imageLiteral(resourceName: "EthereumLogo"))
        ]

    private var indexOfCellBeforeDragging = 0
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = -10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
    }
    
    private func makeNetworkCalls(){
        let currencyStrings = ["bitcoin", "ethereum", "ripple", "litecoin"]
        currencyStrings.forEach { currencyName in
            NetworkManager.shared.getPrice(for: currencyName) { [weak self](root, error) in
                guard let self = self else { return }
                guard let root = root else {
                    print(error)
                    return
                }
                let currency = CurrencyModelNetwork(name: root.name, price: root.marketData.currentPrice.usd)
                
                switch root.name {
                case CurrencyEnums.Bitcoin.rawValue:
                    self.currencies[0] = currency
                case CurrencyEnums.Litecoin.rawValue:
                    self.currencies[1] = currency
                case CurrencyEnums.XRP.rawValue:
                    self.currencies[2] = currency
                case CurrencyEnums.Ethereum.rawValue:
                    self.currencies[3] = currency
                default: break
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }

        }
    }
    
    
    func setupCollectionView(){
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
        return currencies.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButton
        navigationController?.navigationBar.tintColor = .white
        let detailViewController = DetailsViewController()
        detailViewController.title = currencies[indexPath.item].name
        detailViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(detailViewController, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CryptoCell.cellID, for: indexPath) as! CryptoCell
        cell.set(withAssets: imageAssets[indexPath.item], networkData: currencies[indexPath.item])
        return cell
    }

}

extension MainViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width , height: view.frame.height / 4)
    }
    
}


