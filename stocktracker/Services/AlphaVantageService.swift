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
    let SEARCH_ENDPOINT = "SYMBOL_SEARCH"
    let QUOTE_ENDPOINT = "GLOBAL_QUOTE"
    let INTRADAY_ENDPOINT = "TIME_SERIES_INTRADAY"
    let DAILY_ENDPOINT = "TIME_SERIES_DAILY"
    let WEEKLY_ENDPOINT = "TIME_SERIES_WEEKLY"
    let MONTHLY_ENDPOINT = "TIME_SERIES_MONTHLY"

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
    
    func fetchStockQuoteInWatchlistFor(_ stockId: String, _ symbol: String, _ name: String, completion: @escaping (StockQuote) -> ()) {
        guard let url = URL(string: BASE_URL + "\(QUOTE_ENDPOINT)&symbol=\(symbol)&apikey=\(API_KEY)") else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error ?? "")
            }
            guard let data = data, var stock = try? JSONDecoder().decode(StockQuote.self, from: data) else { return }
            DispatchQueue.main.async {
                stock.id = stockId
                stock.name = name
                completion(stock)
            }
        }
        task.resume()
    }
    
    func fetchStockQuote(for stockMatch: StockSearchResults.Match, completion: @escaping (StockQuote) -> ()) {
        let symbol = stockMatch.symbol
        let name = stockMatch.name
        guard let url = URL(string: BASE_URL + "\(QUOTE_ENDPOINT)&symbol=\(symbol)&apikey=\(API_KEY)") else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error ?? "")
            }
            guard let data = data, var stock = try? JSONDecoder().decode(StockQuote.self, from: data) else { return }
            DispatchQueue.main.async {
                stock.name = name
                completion(stock)
            }
        }
        task.resume()
    }

    func fetchStockQuotesFrom(userWatchlist: [String:[String:String]], completion: @escaping ([StockQuote]) -> ()) {
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
        
    func fetchTimeSeries(of timeSeriesType: TimeSeriesType, for symbol: String, completion: @escaping ([String:TimeSeriesSnapshot]) -> ()) {
        switch timeSeriesType {
        case .hourly:
            fetchHourlyTimeSeries(for: symbol) { (timeSeries) in
                completion(timeSeries)
            }
        case .daily:
            fetchDailyTimeSeries(for: symbol) { (timeSeries) in
                completion(timeSeries)
            }
        case .weekly:
            fetchWeeklyTimeSeries(for: symbol) { (timeSeries) in
                completion(timeSeries)
            }
        case .monthly:
            fetchMonthlyTimeSeries(for: symbol) { (timeSeries) in
                completion(timeSeries)
            }
        }
    }
    
    private func fetchHourlyTimeSeries(for symbol: String, completion: @escaping ([String:TimeSeriesSnapshot]) -> ()) {
        guard let url = URL(string: BASE_URL + "\(INTRADAY_ENDPOINT)&symbol=\(symbol)&interval=60min&apikey=\(API_KEY)") else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error ?? "")
            }
            guard let data = data, let model = try? JSONDecoder().decode(HourlyTimeSeries.self, from: data) else { return }
            DispatchQueue.main.async {
                completion(model.timeSeries)
            }
        }
        task.resume()
    }
    
    private func fetchDailyTimeSeries(for symbol: String, completion: @escaping ([String:TimeSeriesSnapshot]) -> ()) {
        guard let url = URL(string: BASE_URL + "\(DAILY_ENDPOINT)&symbol=\(symbol)&apikey=\(API_KEY)") else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error ?? "")
            }
            guard let data = data, let model = try? JSONDecoder().decode(DailyTimeSeries.self, from: data) else { return }
            DispatchQueue.main.async {
                completion(model.timeSeries)
            }
        }
        task.resume()
    }
    
    private func fetchWeeklyTimeSeries(for symbol: String, completion: @escaping ([String:TimeSeriesSnapshot]) -> ()) {
        guard let url = URL(string: BASE_URL + "\(WEEKLY_ENDPOINT)&symbol=\(symbol)&apikey=\(API_KEY)") else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error ?? "")
            }
            guard let data = data, let model = try? JSONDecoder().decode(WeeklyTimeSeries.self, from: data) else { return }
            DispatchQueue.main.async {
                completion(model.timeSeries)
            }
        }
        task.resume()
    }
    
    private func fetchMonthlyTimeSeries(for symbol: String, completion: @escaping ([String:TimeSeriesSnapshot]) -> ()) {
        guard let url = URL(string: BASE_URL + "\(MONTHLY_ENDPOINT)&symbol=\(symbol)&apikey=\(API_KEY)") else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error ?? "")
            }
            guard let data = data, let model = try? JSONDecoder().decode(MonthlyTimeSeries.self, from: data) else { return }
            DispatchQueue.main.async {
                completion(model.timeSeries)
            }
        }
        task.resume()
    }
}
