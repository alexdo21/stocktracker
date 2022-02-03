//
//  ViewController.swift
//  stocktracker
//
//  Created by Alex Do on 8/2/21.
//

import UIKit
import FirebaseDatabase

class StockListController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let cellId = "cellId"
    var stocks: [StockQuote]?
    
//    var stocks: [Stock] = {
//        var apple = Stock()
//        apple.ticker = "AAPL"
//        apple.company = "Apple Inc."
//        apple.stockExchange = "NASDAQ"
//        apple.price = 145.86
//        apple.priceChange = 0.26
//
//        var google = Stock()
//        google.ticker = "GOOG"
//        google.company = "Alphabet Inc."
//        google.stockExchange = "NASDAQ"
//        google.price = 2725.58
//        google.priceChange = -10.56
//
//        var starbucks = Stock()
//        starbucks.ticker = "SBUX"
//        starbucks.company = "Starbucks Corporation"
//        starbucks.stockExchange = "NASDAQ"
//        starbucks.price = 116.50
//        starbucks.priceChange = 0.56
//
//        var nike = Stock()
//        nike.ticker = "NKE"
//        nike.company = "Nike Inc."
//        nike.stockExchange = "NYSE"
//        nike.price = 171.27
//        nike.priceChange = -0.99
//
//        var alibaba = Stock()
//        alibaba.ticker = "BABA"
//        alibaba.company = "Alibaba Group Holding Limited"
//        alibaba.stockExchange = "NYSE"
//        alibaba.price = 194.86
//        alibaba.priceChange = -0.82
//
//        return [apple, google, starbucks, nike, alibaba]
//    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemGray6
        cv.dataSource = self
        cv.delegate = self
        cv.frame = view.bounds
        cv.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        cv.isPagingEnabled = true
        return cv
    }()
    
    private let database = Database.database().reference()
    
    private func fetchStocks() {
        // fetch stocks associated with user of this app
        database.child("symbols").observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                var symbols: [String] = []
                for child in snapshot.children {
                    let symbolSnapshot = child as? DataSnapshot
                    let symbol = symbolSnapshot?.value as! String
                    symbols.append(symbol)
                }
                StockService.sharedInstance.fetchStocks(symbols: symbols, completion: {(stocks: [StockQuote]) in
                    self.stocks = stocks
                    self.collectionView.reloadData()
                })
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchStocks()
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = barAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
        navigationItem.title = "Stocks"
//        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
//        titleLabel.text = "Stocks"
//        titleLabel.font = UIFont.systemFont(ofSize: 30)
//        navigationItem.titleView = titleLabel
        
        collectionView.register(StockCell.self, forCellWithReuseIdentifier: cellId)
        view.addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stocks?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! StockCell
        // if indexPath.item > stocks.count - 1 { return cell }
        cell.stock = self.stocks?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: (view.frame.width - 250))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

