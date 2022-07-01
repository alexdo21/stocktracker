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
            if let price = stock?.globalQuote.price, let priceFloat = Float(price) {
                let roundedPrice = String(format: "%.2f", priceFloat)
                stockPriceView.price.text = roundedPrice
            }
            if let priceChange = stock?.globalQuote.change, let priceChangeFloat = Float(priceChange) {
                let roundedPriceChange = String(format: "%.2f", priceChangeFloat)
                stockPriceView.priceChange.textColor = priceChangeFloat < 0 ? .red : .green
                stockPriceView.priceChange.text = priceChangeFloat < 0 ? "\(roundedPriceChange)" : "+\(roundedPriceChange)"
            }
            if let open = stock?.globalQuote.open, let openFloat = Float(open) {
                let roundedOpen = String(format: "%.2f", openFloat)
                stockInfoContainer.open.value.text = roundedOpen
            }
            if let high = stock?.globalQuote.high, let highFloat = Float(high) {
                let roundedHigh = String(format: "%.2f", highFloat)
                stockInfoContainer.high.value.text = roundedHigh
            }
            if let low = stock?.globalQuote.low, let lowFloat = Float(low) {
                let roundedLow = String(format: "%.2f", lowFloat)
                stockInfoContainer.low.value.text = roundedLow
            }
            if let volume = stock?.globalQuote.volume, let volumeDouble = Double(volume) {
                let formatVolume = volumeDouble.formatPoints()
                stockInfoContainer.volume.value.text = formatVolume
            }
        }
    }
    
    let stockName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    let stockPriceView: StockPriceView = {
        let view = StockPriceView()
        return view
    }()
    
    let stockInfoContainer: StockInfoContainerView = {
        let container = StockInfoContainerView()
        return container
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.addSubview(stockName)
        self.addSubview(stockPriceView)
        self.addSubview(stockInfoContainer)
        
        stockName.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: stockInfoContainer.topAnchor, right: stockPriceView.leftAnchor, padding: .init(top: 13, left: 13, bottom: 20, right: 13))
        stockPriceView.anchor(top: self.topAnchor, left: stockName.rightAnchor, bottom: stockInfoContainer.topAnchor, right: self.rightAnchor, padding: .init(top: 16, left: 13, bottom: 10, right: 20))
        stockInfoContainer.anchor(top: stockPriceView.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, padding: .init(top: 0, left: 12, bottom: 7, right: 12))
    }
}
