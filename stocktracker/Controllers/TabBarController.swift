//
//  TabBarController.swift
//  stocktracker
//
//  Created by Alex Do on 8/4/21.
//

import UIKit
import FirebaseDatabase

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private func setTitleForNavBarItem(selected tabBarItem: UITabBarItem) {
        if let title = tabBarItem.title {
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
            titleLabel.text = title
            titleLabel.font = UIFont.systemFont(ofSize: 30)
            viewControllers?[tabBarItem.tag].navigationItem.titleView = titleLabel
        }
    }
    
    private let database = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNewEntry()
        
        self.hidesBottomBarWhenPushed = false
        tabBar.tintColor = .black
        tabBar.isTranslucent = false
        
        let barAppearance = UITabBarAppearance()
        barAppearance.backgroundColor = .white
        tabBar.standardAppearance = barAppearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = barAppearance
        }
        
        let stockListVC = UINavigationController(rootViewController: StockListController())
        let stockListTabItem = UITabBarItem(title: "Stocks", image: UIImage(systemName: "house"), tag: 0)
        stockListVC.tabBarItem = stockListTabItem
        
        let searchVC = UINavigationController(rootViewController: SearchStockController())
        let searchTabItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        searchVC.tabBarItem = searchTabItem
        
        self.setViewControllers([stockListVC, searchVC], animated: false)
        self.selectedViewController = stockListVC

    }
    
    private func addNewEntry() {
        database.child("Name").setValue("Alex Do")
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        setTitleForNavBarItem(selected: item)
    }
}
