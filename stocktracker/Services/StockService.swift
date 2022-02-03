//
//  StockService.swift
//  stocktracker
//
//  Created by Alex Do on 8/3/21.
//

import UIKit

class StockService: NSObject {
    static let sharedInstance = StockService()
    
    let API_KEY = "LX6YZLO8UJWSQ3NO"
    let QUOTE_ENDPOINT = "GLOBAL_QUOTE"
    let SEARCH_ENDPOINT = "SYMBOL_SEARCH"
    
    func fetchBestMatchingStocksBy(keyword: String, completion: @escaping ([StockSearchResults.Match]) -> ()) {
        if keyword.isEmpty {
            completion([])
        }
        guard let url = URL(string: "https://www.alphavantage.co/query?function=\(SEARCH_ENDPOINT)&keywords=\(keyword)&apikey=\(API_KEY)") else { return }
        
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

    func fetchStocks(symbols: [String], completion: @escaping ([StockQuote]) -> ()) {
        let dispatchGroup = DispatchGroup()
        var stocks: [StockQuote] = []
        for symbol in symbols {
            dispatchGroup.enter()
            guard let url = URL(string: "https://www.alphavantage.co/query?function=\(QUOTE_ENDPOINT)&symbol=\(symbol)&apikey=\(API_KEY)") else { return }
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error ?? "")
                }
                guard let data = data, let stock = try? JSONDecoder().decode(StockQuote.self, from: data) else {
                    dispatchGroup.leave()
                    return
                }
                
                DispatchQueue.main.async {
                    stocks.append(stock)
                    dispatchGroup.leave()
                }
            }).resume()
        }
        dispatchGroup.notify(queue: .main) {
            completion(stocks)
        }
        
    }
}
