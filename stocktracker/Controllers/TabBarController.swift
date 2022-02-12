//
//  TabBarController.swift
//  stocktracker
//
//  Created by Alex Do on 8/4/21.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    
    private func setTitleForNavBarItem(selected tabBarItem: UITabBarItem) {
        if let title = tabBarItem.title {
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
            titleLabel.text = title
            titleLabel.font = UIFont.systemFont(ofSize: 30)
            viewControllers?[tabBarItem.tag].navigationItem.titleView = titleLabel
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hidesBottomBarWhenPushed = false
        tabBar.tintColor = .black
        tabBar.isTranslucent = false
        
        let barAppearance = UITabBarAppearance()
        barAppearance.backgroundColor = .white
        tabBar.standardAppearance = barAppearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = barAppearance
        }
        
        let watchlistVC = WatchlistController()
        
        let homeController = HomeController()
        homeController.watchlistController = watchlistVC
        let homeNVC = UINavigationController(rootViewController: homeController)
        let homeTabItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        homeNVC.tabBarItem = homeTabItem
        
        let searchController = SearchController()
        searchController.watchlistController = watchlistVC
        let searchNVC = UINavigationController(rootViewController: searchController)
        let searchTabItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        searchNVC.tabBarItem = searchTabItem
        
        self.setViewControllers([homeNVC, searchNVC], animated: false)
        self.selectedViewController = homeNVC
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        setTitleForNavBarItem(selected: item)
    }
}
