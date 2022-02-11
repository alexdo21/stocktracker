//
//  ViewController.swift
//  stocktracker
//
//  Created by Alex Do on 8/2/21.
//

import UIKit
import FirebaseDatabase

class StockListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var stocks: [StockQuote]?
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .systemGray6
        tv.dataSource = self
        tv.delegate = self
        tv.frame = view.bounds
        return tv
    }()
    
    private let database = Database.database().reference()
    
    private func fetchStocks() {
        // fetch stocks associated with user of this app
        database.child("symbols").observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                var symbols: [String] = []
                for child in snapshot.children {
                    let symbolSnapshot = child as? DataSnapshot
                    let symbol = symbolSnapshot?.value as! String
                    symbols.append(symbol)
                }
                print("FireBase: \(symbols.count)")
                StockService.sharedInstance.fetchStocks(symbols: symbols, completion: {(stocks: [StockQuote]) in
                    print("AlphaVantage: \(stocks.count)")
                    self.stocks = stocks
                    self.tableView.reloadData()
                })
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchStocks()
        
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
        stockQuoteCell.stock = stocks?[indexPath.item]
        return stockQuoteCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { _, indexPath in
            self.stocks?.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return [deleteAction]
    }
}

