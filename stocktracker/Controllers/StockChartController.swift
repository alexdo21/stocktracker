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
        sc.backgroundColor = .systemYellow
        return sc
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray
        view.addSubview(dashboardView)
        view.addSubview(chartView)
        view.addSubview(segmentedControl)
        
        setupViews()
    }
    
//    override func viewDidLayoutSubviews() {
//        setupViews()
//    }
    
    func setupViews() {
        
        
        
        // horizontal constraints
        view.addConstraintsWithFormat(format: "H:|-23-[v0(344)]-23-|", views: dashboardView)
        view.addConstraintsWithFormat(format: "H:|-23-[v0(344)]-23-|", views: chartView)
        view.addConstraintsWithFormat(format: "H:|-23-[v0(344)]-23-|", views: segmentedControl)
        
        // vertical constraints
        view.addConstraintsWithFormat(format: "V:|-15-[v0(96)]-9-[v1(300)]-14-[v2(32)]-207-|", views: dashboardView, chartView, segmentedControl)
        
    }
}

extension UIView {
    func centerInSuperview() {
        center.x = superview!.bounds.width / 2
        center.y = superview!.bounds.width / 2
    }
}
