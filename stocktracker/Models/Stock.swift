//
//  Stock.swift
//  stocktracker
//
//  Created by Alex Do on 8/3/21.
//

import UIKit
import Charts

struct StockQuote: Codable {
    var id: String?
    var name: String?
    var isFavorited: Bool = false
    var stockChart: StockChartController?
    var hourlyChartData: LineChartData?
    
    struct GlobalQuote: Codable {
        let symbol, open, high, low, price, volume, latestTradingDay, previousClose, change, changePercent: String
        
        enum CodingKeys: String, CodingKey {
            case symbol = "01. symbol"
            case open = "02. open"
            case high = "03. high"
            case low = "04. low"
            case price = "05. price"
            case volume = "06. volume"
            case latestTradingDay = "07. latest trading day"
            case previousClose = "08. previous close"
            case change = "09. change"
            case changePercent = "10. change percent"
        }
    }
    
    let globalQuote: GlobalQuote
    
    enum CodingKeys: String, CodingKey {
        case globalQuote = "Global Quote"
    }
}

struct StockSearchResults: Codable {
    struct Match: Codable {
        var id: String?
        var isFavorited: Bool = false
        let symbol, name, type, region, marketOpen, marketClose, timezone, currency, matchScore: String
        
        enum CodingKeys: String, CodingKey {
            case symbol = "1. symbol"
            case name = "2. name"
            case type = "3. type"
            case region = "4. region"
            case marketOpen = "5. marketOpen"
            case marketClose = "6. marketClose"
            case timezone = "7. timezone"
            case currency = "8. currency"
            case matchScore = "9. matchScore"
        }
    }
    
    let bestMatches: [Match]
    
    enum CodingKeys: String, CodingKey {
        case bestMatches = "bestMatches"
    }
}
