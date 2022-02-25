//
//  StockChartController.swift
//  stocktracker
//
//  Created by Alex Do on 2/14/22.
//

import UIKit
import Charts

class StockChartController : UIViewController {
    let dashboardView: UIView = {
        let dv = UIView()
        dv.backgroundColor = .systemYellow
        return dv
    }()
    lazy var chartView: LineChartView = {
        let cv = LineChartView()
        cv.backgroundColor = .systemBlue
        return cv
    }()
    let segmentedControl: UISegmentedControl = {
        let items = ["1D", "1W", "1M", "1Y"]
        let sc = UISegmentedControl(items: items)
        sc.selectedSegmentIndex = 0
        sc.backgroundColor = .systemYellow
        return sc
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        
        view.addSubview(dashboardView)
        view.addSubview(chartView)
        view.addSubview(segmentedControl)
        
        dashboardView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, padding: .init(top: 15, left: 23, bottom: 0, right: 23), size: .init(width: 344, height: 96))
        chartView.anchor(top: dashboardView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, padding: .init(top: 14, left: 23, bottom: 0, right: 23), size: .init(width: 344, height: 300))
        segmentedControl.anchor(top: chartView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, padding: .init(top: 14, left: 23, bottom: 15, right: 23), size: .init(width: 344, height: 32))
    }
}
