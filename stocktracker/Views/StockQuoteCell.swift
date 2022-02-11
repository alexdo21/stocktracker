//
//  StockCell.swift
//  stocktracker
//
//  Created by Alex Do on 8/3/21.
//

import UIKit

class StockQuoteCell: CustomTableViewCell {
    static let identifier = "StockQuoteCell"
    var stock: StockQuote? {
        didSet {
            tickerLabel.text = stock?.globalQuote.symbol
            corpLabel.text = "ABC"
            if let price = stock?.globalQuote.price, let priceFloat = Float(price) {
                let roundedPrice = String(format: "%.2f", priceFloat)
                priceLabel.text = roundedPrice
            }
            if let priceChange = stock?.globalQuote.change, let priceChangeFloat = Float(priceChange) {
                let roundedPriceChange = String(format: "%.2f", priceChangeFloat)
                if (priceChangeFloat < 0) {
                    priceChangeLabel.backgroundColor = .systemRed
                    priceChangeLabel.text = "-\(roundedPriceChange)"
                } else {
                    priceChangeLabel.backgroundColor = .green
                    priceChangeLabel.text = "+\(roundedPriceChange)"
                }
            }

        }
    }
    
    let tickerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    let corpLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()

    let stockGraph: UIView = {
        let graph = UIView()
        graph.backgroundColor = .systemGreen
        return graph
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    let priceChangeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        contentView.addSubview(tickerLabel)
        contentView.addSubview(corpLabel)
        contentView.addSubview(stockGraph)
        contentView.addSubview(priceLabel)
        contentView.addSubview(priceChangeLabel)
        
        // Horizontal Constraints
        addConstrintsWithFormat(format: "H:|-16-[v0(118)]-16-[v1(127)]-10-[v2(93)]-10-|", views: tickerLabel, stockGraph, priceLabel)
        addConstrintsWithFormat(format: "H:|-16-[v0(115)]-19-[v1(127)]-34-[v2(45)]-34-|", views: corpLabel, stockGraph, priceChangeLabel)

        // Vertical Constraints
        addConstrintsWithFormat(format: "V:|-19-[v0(29)]-11-[v1(21)]-20-|", views: tickerLabel, corpLabel)
        addConstrintsWithFormat(format: "V:|-14-[v0(69)]-17-|", views: stockGraph)
        addConstrintsWithFormat(format: "V:|-31-[v0(17)]-5-[v1(16)]-31-|", views: priceLabel, priceChangeLabel)

        
    }
}
