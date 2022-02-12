//
//  StockSearchResultCell.swift
//  stocktracker
//
//  Created by Alex Do on 2/10/22.
//

import UIKit

class StockSearchResultCell: CustomTableViewCell {
    static let identifier = "StockSearchResultCell"
    var stockMatch: StockSearchResults.Match? {
        didSet {
            if let ticker = stockMatch?.symbol, let region = stockMatch?.region, let type = stockMatch?.type {
                let text = ticker + " " + region + " • " + type
                let attributedText = NSMutableAttributedString(string: text)

                attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: .bold), range: NSRange(location: 0, length: ticker.count))
                attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 11, weight: .light), range: NSRange(location: ticker.count + 1, length: region.count + 3 + type.count))
                
                tickerRegionTypeLabel.attributedText = attributedText
            }
            corpLabel.text = stockMatch?.name
            
            if let favorited = stockMatch?.isFavorited {
                if favorited {
                    favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                } else {
                    favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
                }
            }
        }
    }
    
    let tickerRegionTypeLabel: UILabel = {
        return UILabel()
    }()
    let corpLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleAddDelete), for: .touchUpInside)
        return button
    }()
    
    @objc func handleAddDelete() {
        print("Favorite Pressed!")
        print(self.stockMatch ?? "Fail")
        if let favorited = stockMatch?.isFavorited, let symbol = stockMatch?.symbol, let name = stockMatch?.name {
            if !favorited {
                // add
                FirebaseService.sharedInstance.addStockToWatchlist(symbol: symbol, name: name) { stockId in
                    self.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                    self.stockMatch?.id = stockId
                    self.stockMatch?.isFavorited = true
                    print("Favorite added!")
                }
            } else if let stockId = stockMatch?.id {
                // delete
                if !stockId.isEmpty {
                    FirebaseService.sharedInstance.deleteStockFromWatchlist(stockId: stockId) {
                        self.favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
                        self.stockMatch?.id = ""
                        self.stockMatch?.isFavorited = false
                        print("Favorite deleted!")
                    }
                }
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        contentView.addSubview(tickerRegionTypeLabel)
        contentView.addSubview(corpLabel)
        contentView.addSubview(favoriteButton)
        
        // Horizontal Constraints
        addConstrintsWithFormat(format: "H:|-9-[v0(307)]-38-[v1(24)]-12-|", views: tickerRegionTypeLabel, favoriteButton)
        addConstrintsWithFormat(format: "H:|-9-[v0(307)]-38-[v1(24)]-12-|", views: corpLabel, favoriteButton)
        
        // Vertical Constraints
        addConstrintsWithFormat(format: "V:|-6-[v0(22)]-0-[v1(20)]-2-|", views: tickerRegionTypeLabel, corpLabel)
        addConstrintsWithFormat(format: "V:|-13-[v0(24)]-13-|", views: favoriteButton)
    }
}
