//
//  WatchlistController.swift
//  stocktracker
//
//  Created by Alex Do on 2/12/22.
//

import UIKit

class WatchlistController {
    var stocks: [StockQuote] = []
    
    func listenForUpdates(completion: @escaping () -> Void) {
        FirebaseService.sharedInstance.listenForUserWatchlistAdd { (stockId, symbol, name) in
            AlphaVantageService.sharedInstance.fetchQuoteFor(stockId, symbol, name) { (stock: StockQuote) in
                print("AlphaVantage: \(stock)")
                self.stocks.append(stock)
                completion()
            }
        }
        FirebaseService.sharedInstance.listenForUserWatchlistDelete { (stockId) in
            if let index = self.stocks.firstIndex(where: { $0.id == stockId }) {
                self.stocks.remove(at: index)
            }
        }
    }
    
    func fetchStocks(completion: @escaping () -> Void) {
        FirebaseService.sharedInstance.fetchUserWatchlist { userWatchlist in
            print("Firebase: \(userWatchlist.count)")
            if !userWatchlist.isEmpty {
                AlphaVantageService.sharedInstance.fetchStockQuotesFrom(userWatchlist: userWatchlist) { (stocks: [StockQuote]) in
                    print("AlphaVantage: \(stocks.count)")
                    if stocks.isEmpty {
                        completion()
                    } else {
                        self.stocks = stocks
                        completion()
                    }
                }
            }
        }
    }
}
