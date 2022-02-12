//
//  StockService.swift
//  stocktracker
//
//  Created by Alex Do on 8/3/21.
//

import UIKit

class AlphaVantageService: NSObject {
    static let sharedInstance = AlphaVantageService()
    
    let BASE_URL = "https://www.alphavantage.co/query?function="
    let API_KEY = "LX6YZLO8UJWSQ3NO"
    let QUOTE_ENDPOINT = "GLOBAL_QUOTE"
    let SEARCH_ENDPOINT = "SYMBOL_SEARCH"
    
    func fetchBestMatchingStocksBy(keyword: String, completion: @escaping ([StockSearchResults.Match]) -> ()) {
        if keyword.isEmpty {
            completion([])
        }
        guard let url = URL(string: BASE_URL + "\(SEARCH_ENDPOINT)&keywords=\(keyword)&apikey=\(API_KEY)") else { return }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error ?? "")
                return
            }
            
            guard let data = data, let stockResults = try? JSONDecoder().decode(StockSearchResults.self, from: data) else {
                return
            }

            DispatchQueue.main.async {
                completion(stockResults.bestMatches)
            }
            
        }).resume()
    }
    
//    func fetchQuoteFor(stockId: String, symbol: String, name: String)

    func fetchStockQuotesFromUserWatchlist(userWatchlist: [String:[String:String]], completion: @escaping ([StockQuote]) -> ()) {
        let dispatchGroup = DispatchGroup()
        var stocks: [StockQuote] = []
        for (stockId, stockData) in userWatchlist {
            if let symbol = stockData["symbol"], let name = stockData["name"] {
                dispatchGroup.enter()
                guard let url = URL(string: BASE_URL + "\(QUOTE_ENDPOINT)&symbol=\(symbol)&apikey=\(API_KEY)") else { return }
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    if error != nil {
                        print(error ?? "")
                    }
                    guard let data = data, var stock = try? JSONDecoder().decode(StockQuote.self, from: data) else {
                        dispatchGroup.leave()
                        return
                    }
                    DispatchQueue.main.async {
                        stock.id = stockId
                        stock.name = name
                        stocks.append(stock)
                        dispatchGroup.leave()
                    }
                }).resume()
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(stocks)
        }
        
    }
}
