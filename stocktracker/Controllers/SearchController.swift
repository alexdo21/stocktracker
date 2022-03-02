//
//  SearchStockController.swift
//  stocktracker
//
//  Created by Alex Do on 8/5/21.
//

import UIKit

class SearchController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    var watchlistController: WatchlistController?
    var stocks: [StockQuote] {
        return watchlistController?.stocks ?? []
    }
    
    var stockMatches: [StockSearchResults.Match]?
    
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .systemGray6
        tv.dataSource = self
        tv.delegate = self
        tv.frame = view.bounds
        return tv
    }()
    
    override func viewWillAppear(_ animated: Bool) {
//        for cell in tableView.visibleCells {
//            let resultCell = cell as! StockSearchResultCell
//            if var stockMatch = resultCell.stockMatch, let _ = stocks.first(where: {$0.globalQuote.symbol == stockMatch.symbol}) {
//                stockMatch.isFavorited = true
//            }
//        }
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "to the moon 🚀"
        searchController.obscuresBackgroundDuringPresentation = false
        
        tableView.register(StockSearchResultCell.self, forCellReuseIdentifier: StockSearchResultCell.identifier)
        view.addSubview(tableView)
    }
    
    var searchTask: DispatchWorkItem?
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchTask?.cancel()
        
        let task = DispatchWorkItem { [weak self] in
            AlphaVantageService.sharedInstance.fetchBestMatchingStocksBy(keyword: searchText, completion: { (stockMatches: [StockSearchResults.Match]) in
                print(stockMatches.count)
                self?.stockMatches = stockMatches
                self?.tableView.reloadData()
            })
        }
        
        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: task)
    }
        
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.stockMatches?.removeAll()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stockSearchResultCell = tableView.dequeueReusableCell(withIdentifier: StockSearchResultCell.identifier, for: indexPath) as! StockSearchResultCell
        if var stockMatch = stockMatches?[indexPath.row] {
            if let existingStock = stocks.first(where: {$0.globalQuote.symbol == stockMatch.symbol}) {
                if let stockId = existingStock.id {
                    stockMatch.id = stockId
                }
                stockMatch.isFavorited = true
            }
            stockSearchResultCell.stockMatch = stockMatch
        }

        return stockSearchResultCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockMatches?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let stockMatch = stockMatches?[indexPath.row] {
            if let existingStock = stocks.first(where: {$0.globalQuote.symbol == stockMatch.symbol}) {
                if let stockChart = existingStock.stockChart {
                    self.navigationController?.pushViewController(stockChart, animated: true)
                } else {
                    self.navigationController?.pushViewController(StockChartController(with: existingStock), animated: true)
                }
            } else {
                AlphaVantageService.sharedInstance.fetchStockQuote(for: stockMatch) { (stock) in
                    self.navigationController?.pushViewController(StockChartController(with: stock), animated: true)
                }
            }
        }
    }
    
}
