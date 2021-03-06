//
//  StockCell.swift
//  stocktracker
//
//  Created by Alex Do on 8/3/21.
//

import UIKit
import Charts

class StockQuoteCell: CustomTableViewCell {
    static let identifier = "StockQuoteCell"
    var stock: StockQuote? {
        didSet {
            tickerLabel.text = stock?.globalQuote.symbol
            corpLabel.text = stock?.name
            if let price = stock?.globalQuote.price, let priceFloat = Float(price) {
                let roundedPrice = String(format: "%.2f", priceFloat)
                priceLabel.text = roundedPrice
            }
            if let priceChange = stock?.globalQuote.change, let priceChangeFloat = Float(priceChange) {
                let roundedPriceChange = String(format: "%.2f", priceChangeFloat)
                priceChangeLabel.backgroundColor = priceChangeFloat < 0 ? .red : .green
                priceChangeLabel.text = priceChangeFloat < 0 ? "\(roundedPriceChange)" : "+\(roundedPriceChange)"
            }
            if let hourlyChartData = stock?.hourlyChartData, let previousCloseLine = Double((stock?.globalQuote.previousClose)!) {
                let previousCloseLine = ChartLimitLine(limit: previousCloseLine)
                previousCloseLine.lineWidth = 1
                previousCloseLine.lineDashLengths = [5, 5]
                previousCloseLine.lineColor = UIColor.lightGray
                self.stockGraph.leftAxis.addLimitLine(previousCloseLine)
                self.stockGraph.data = hourlyChartData
            }
        }
    }
    
    let tickerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    let corpLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        return label
    }()

    lazy var stockGraph: LineChartView = {
        let graph = LineChartView()
        graph.backgroundColor = .white
        graph.chartDescription?.enabled = false
        
        graph.xAxis.drawGridLinesEnabled = false
        graph.leftAxis.drawGridLinesEnabled = false
        
        graph.xAxis.drawLabelsEnabled = false
        graph.leftAxis.drawLabelsEnabled = false
        
        graph.xAxis.drawAxisLineEnabled = false
        graph.leftAxis.drawAxisLineEnabled = false
        
        graph.rightAxis.enabled = false
        graph.legend.enabled = false
        graph.drawBordersEnabled = false
        
        graph.isUserInteractionEnabled = false
        return graph
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    let priceChangeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        
        contentView.addSubview(tickerLabel)
        contentView.addSubview(corpLabel)
        contentView.addSubview(stockGraph)
        contentView.addSubview(priceLabel)
        contentView.addSubview(priceChangeLabel)
        
        // Horizontal Constraints
        addConstraintsWithFormat(format: "H:|-16-[v0(118)]-16-[v1(127)]-10-[v2(93)]-10-|", views: tickerLabel, stockGraph, priceLabel)
        addConstraintsWithFormat(format: "H:|-16-[v0(115)]-19-[v1(127)]-34-[v2(45)]-34-|", views: corpLabel, stockGraph, priceChangeLabel)

        // Vertical Constraints
        addConstraintsWithFormat(format: "V:|-19-[v0(29)]-11-[v1(21)]-20-|", views: tickerLabel, corpLabel)
        addConstraintsWithFormat(format: "V:|-14-[v0(69)]-17-|", views: stockGraph)
        addConstraintsWithFormat(format: "V:|-31-[v0(17)]-5-[v1(16)]-31-|", views: priceLabel, priceChangeLabel)
    }
}
