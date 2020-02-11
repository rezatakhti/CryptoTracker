//
//  ViewController.swift
//  CurrencyTracker
//
//  Created by Reza Takhti on 12/31/19.
//  Copyright © 2019 Reza Takhti. All rights reserved.
//

import UIKit
protocol DetailedViewDelegate : class {
    func didSendLogoImage(logoImage : UIImage)
}

class MainViewController: UIViewController {
    let transition = PopAnimator()
    
    var currencies : Array<CurrencyModelNetwork> = Array(repeating: CurrencyModelNetwork(name: "", price: 0), count: 4) {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    lazy var indicator = createActivityIndicator()
    
    weak var delegate : DetailedViewDelegate?
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.refreshControl = UIRefreshControl()
        cv.refreshControl?.addTarget(self, action: #selector(networkCallStarted), for: .valueChanged)
        cv.decelerationRate = .fast
        cv.backgroundColor = .clear
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        cv.delegate = self
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.delaysContentTouches = false
        cv.register(CryptoCell.self, forCellWithReuseIdentifier: CryptoCell.cellID)
        cv.register(DateHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DateHeader.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        indicator.startAnimating()
        makeNetworkCalls()
    }
    
    @objc private func networkCallStarted(){
        makeNetworkCalls()
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
                DispatchQueue.main.async{
                    self.collectionView.refreshControl?.endRefreshing()
                    self.indicator.stopAnimating()
                }
                
            }

        }
    }
    
    
    func setupViews(){
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
    }

    func setupView(){
        view.backgroundColor = .white
    }
}

extension MainViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsViewController = DetailsViewController()
        detailsViewController.title = currencies[indexPath.item].name
        detailsViewController.modalPresentationStyle = .fullScreen
        present(detailsViewController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CryptoCell.cellID, for: indexPath) as! CryptoCell
        cell.set(networkData: currencies[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DateHeader.identifier, for: indexPath) as! DateHeader
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
}

extension MainViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width , height: view.frame.height / 3)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(collectionView.contentOffset.y)
    }
}

