//
//  WatchlistController.swift
//  stocktracker
//
//  Created by Alex Do on 2/12/22.
//

import UIKit

class WatchlistController {
    var stocks: [StockQuote]?
    
//    func listenForUpdates() {
//        FirebaseService.sharedInstance.listenToUserWatchlist { newStock in
//            AlphaVantageService.sharedInstance.fetchQuoteFor(stock: newStock) { (stock: StockQuote) in
//                self.stocks.append(stock)
//                
//            }
//            
//        }
//    }
    
    func fetchStocks(completion: @escaping () -> Void) {
        FirebaseService.sharedInstance.fetchUserWatchlist { userWatchlist in
            print("Firebase: \(userWatchlist.count)")
            if !userWatchlist.isEmpty {
                AlphaVantageService.sharedInstance.fetchStockQuotesFromUserWatchlist(userWatchlist: userWatchlist) { (stocks: [StockQuote]) in
                    print("AlphaVantage: \(stocks.count)")
                    self.stocks = stocks
                    completion()
                }
            }
        }
//        FirebaseService.sharedInstance.database.child("userWatchlist").observeSingleEvent(of: .value, with: { snapshot in
//            if snapshot.exists() {
//                let userWatchlist = snapshot.value as! [String:String]
//                print("Firebase: \(userWatchlist.count)")
//                AlphaVantageService.sharedInstance.fetchStocksFromUserWatchlist(userWatchlist: userWatchlist) { (stocks: [StockQuote]) in
//                    print("AlphaVantage: \(stocks.count)")
//                    self.stocks = stocks
//                    completion()
//                }
//            }
//        })
    }
}
