//
//  ViewController.swift
//  stocktracker
//
//  Created by Alex Do on 8/2/21.
//

import UIKit
import Charts

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var watchlistController: WatchlistController?
    var stocks: [StockQuote] {
        return watchlistController?.stocks ?? []
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refreshWatchlist), for: .valueChanged)
        return rc
    }()
    
    @objc private func refreshWatchlist() {
        self.watchlistController?.fetchStocks {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }

    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .systemGray6
        tv.dataSource = self
        tv.delegate = self
        tv.refreshControl = refreshControl
        tv.frame = view.bounds
        return tv
    }()
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.watchlistController?.listenForUpdates() {
            self.tableView.reloadData()
        }
                
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = barAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = barAppearance
        navigationItem.title = "Stocks"
        
        tableView.register(StockQuoteCell.self, forCellReuseIdentifier: StockQuoteCell.identifier)
        view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stockQuoteCell = tableView.dequeueReusableCell(withIdentifier: StockQuoteCell.identifier, for: indexPath) as! StockQuoteCell
        stockQuoteCell.stock = stocks[indexPath.row]
        return stockQuoteCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let stock = stocks[indexPath.row]
        if let hourlyChartData = stock.hourlyChartData {
            if let stockChartController = stock.stockChart {
                navigationController?.pushViewController(stockChartController, animated: true)
            } else {
                let stockChartController = StockChartController(with: stock)
                stockChartController.chartDataList[0] = hourlyChartData
                watchlistController?.stocks[indexPath.row].stockChart = stockChartController
                navigationController?.pushViewController(stockChartController, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { _, indexPath in
            if let stock = self.watchlistController?.stocks[indexPath.row], let stockId = stock.id {
                FirebaseService.sharedInstance.deleteStockFromWatchlist(stockId: stockId) {
                    self.watchlistController?.stocks.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
        return [deleteAction]
    }
}

