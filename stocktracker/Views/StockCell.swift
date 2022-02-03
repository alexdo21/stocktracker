//
//  StockCell.swift
//  stocktracker
//
//  Created by Alex Do on 8/3/21.
//

import UIKit

class StockCell: BaseCell {
    
    var stock: StockQuote? {
        didSet {
            tickerLabel.text = stock?.globalQuote.symbol
            corpLabel.text = stock?.globalQuote.volume
            stockExchangeLabel.text = stock?.globalQuote.latestTradingDay
            
            priceLabel.text = stock?.globalQuote.price
            if let priceChange = stock?.globalQuote.change {
                if let priceFloat = Float(priceChange) {
                    if (priceFloat < 0) {
                        priceChangeLabel.textColor = .systemRed
                        priceChangeLabel.text = "\(priceFloat)"
                    } else {
                        priceChangeLabel.textColor = .systemGreen
                        priceChangeLabel.text = "+\(priceFloat)"
                    }
                }
            }

        }
    }
    
    let tickerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()
    
    let corpLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let stockExchangeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .lightGray
        return label
    }()
    
    let stockGraph: UIView = {
        let graph = UIView()
        return graph
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let priceChangeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        setupTile()
        
        addSubview(tickerLabel)
        addSubview(corpLabel)
        addSubview(stockExchangeLabel)
        addSubview(stockGraph)
        addSubview(priceLabel)
        addSubview(priceChangeLabel)
        
        // Horizontal Constraints
        addConstrintsWithFormat(format: "H:|-12-[v0(210)]-8-[v1]-12-|", views: tickerLabel, stockGraph)
        addConstrintsWithFormat(format: "H:|-12-[v0(210)]-8-[v1]-12-|", views: corpLabel, priceLabel)
        addConstrintsWithFormat(format: "H:|-12-[v0(210)]-8-[v1]-12-|", views: stockExchangeLabel, priceChangeLabel)
        
        // Vertical Constraints
        addConstrintsWithFormat(format: "V:|-12-[v0(60)]-8-[v1(20)]-8-[v2(20)]", views: tickerLabel, corpLabel, stockExchangeLabel)
        addConstrintsWithFormat(format: "V:|-12-[v0(60)]-8-[v1(20)]-8-[v2(20)]", views: stockGraph, priceLabel, priceChangeLabel)

        
    }
    
    private func setupTile() {
        let cornerRadius: CGFloat = 10.0
        
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
        
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 0.10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        
        backgroundColor = .white
    }
    
}
