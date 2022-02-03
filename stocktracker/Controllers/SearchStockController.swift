//
//  SearchStockController.swift
//  stocktracker
//
//  Created by Alex Do on 8/5/21.
//

import UIKit

class SearchStockController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var stockMatches = [StockSearchResults.Match]()
    
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .systemGray6
        tv.dataSource = self
        tv.delegate = self
        tv.frame = view.bounds
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "to the moon 🚀"
        searchController.obscuresBackgroundDuringPresentation = false
        
        setupTableView()
    }
        
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        view.addSubview(tableView)
    }
    
    var searchTask: DispatchWorkItem?
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchTask?.cancel()
        
        let task = DispatchWorkItem { [weak self] in
            StockService.sharedInstance.fetchBestMatchingStocksBy(keyword: searchText, completion: { (stockMatches: [StockSearchResults.Match]) in
                print(stockMatches.count)
                self?.stockMatches = stockMatches
                self?.tableView.reloadData()
            })
        }
        
        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: task)
        
    }
        
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.stockMatches.removeAll()
        self.tableView.reloadData()
    }
    
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        tableViewCell.textLabel?.text = "\(stockMatches[indexPath.item].symbol) • \(stockMatches[indexPath.item].name)"
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockMatches.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // navigationController?.pushViewController(UIViewController(), animated: true)
    }
    
}
