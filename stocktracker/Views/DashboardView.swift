//
//  DashboardController.swift
//  stocktracker
//
//  Created by Alex Do on 2/28/22.
//

import UIKit

class DashboardView: UIView {
    var stock: StockQuote? {
        didSet {
            stockName.text = stock?.name
            stockPrice.text = stock?.globalQuote.price
            stockPriceChange.text = stock?.globalQuote.change
            if let favorited = stock?.isFavorited {
                if favorited {
                    favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                } else {
                    favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
                }
            }
        }
    }
    
    let stockName: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleAddDelete), for: .touchUpInside)
        return button
    }()
    
    let stockPrice: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let stockPriceChange: UILabel = {
        let label = UILabel()
        return label
    }()
    
    @objc func handleAddDelete() {
        print("Favorite Pressed!")
        if let favorited = stock?.isFavorited, let symbol = stock?.globalQuote.symbol, let name = stock?.name {
            if !favorited {
                // add
                FirebaseService.sharedInstance.addStockToWatchlist(symbol: symbol, name: name) { stockId in
                    self.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                    self.stock?.id = stockId
                    self.stock?.isFavorited = true
                    print("Favorite added!")
                }
            } else if let stockId = stock?.id {
                // delete
                FirebaseService.sharedInstance.deleteStockFromWatchlist(stockId: stockId) {
                    self.favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
                    self.stock?.id = ""
                    self.stock?.isFavorited = false
                    print("Favorite deleted!")
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        self.backgroundColor = .white
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
