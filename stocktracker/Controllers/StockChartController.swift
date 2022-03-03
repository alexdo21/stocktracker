//
//  StockChartController.swift
//  stocktracker
//
//  Created by Alex Do on 2/14/22.
//

import UIKit
import Charts

class StockChartController: UIViewController {
    var stock: StockQuote

    var chartDataList = [LineChartData?](repeating: nil, count: 4)
    var timeSeriesList = [[String:TimeSeriesSnapshot]?](repeating: nil, count: 4)

    lazy var chartView: LineChartView = {
        let cv = LineChartView()
        cv.backgroundColor = .clear
        cv.layer.cornerRadius = 100
        
        let xAxis = cv.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 8, weight: .bold)
        xAxis.labelTextColor = .black
        xAxis.valueFormatter = DateValueFormatter()
        
        let yAxis = cv.leftAxis
        yAxis.labelFont = .systemFont(ofSize: 8, weight: .bold)
        if let previousCloseLine = Double(stock.globalQuote.previousClose) {
            let previousCloseLine = ChartLimitLine(limit: previousCloseLine)
            previousCloseLine.lineWidth = 1
            previousCloseLine.lineDashLengths = [5, 5]
            previousCloseLine.lineColor = .lightGray
            yAxis.addLimitLine(previousCloseLine)
        }
        
        cv.rightAxis.enabled = false
        cv.legend.enabled = false
        cv.extraBottomOffset = 10
        cv.xAxis.drawGridLinesEnabled = false
        cv.leftAxis.drawGridLinesEnabled = false
                
        return cv
    }()
    lazy var segmentedControl: UISegmentedControl = {
        let items = ["1H", "1D", "1W", "1M"]
        let sc = UISegmentedControl(items: items)
        sc.selectedSegmentIndex = 0
        sc.backgroundColor = .white
        sc.addTarget(self, action: #selector(handleSelect), for: .valueChanged)
        return sc
    }()
    
    @objc private func handleSelect(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 && timeSeriesList[0] == nil {
            fetchTimeSeries(of: .hourly) { self.chartView.data = self.chartDataList[0] }
        } else if sender.selectedSegmentIndex == 1 && timeSeriesList[1] == nil {
            fetchTimeSeries(of: .daily) { self.chartView.data = self.chartDataList[1] }
        } else if sender.selectedSegmentIndex == 2 && timeSeriesList[2] == nil {
            fetchTimeSeries(of: .weekly) { self.chartView.data = self.chartDataList[2] }
        } else if sender.selectedSegmentIndex == 3 && timeSeriesList[3] == nil {
            fetchTimeSeries(of: .monthly) { self.chartView.data = self.chartDataList[3] }
        }
        chartView.xAxis.valueFormatter = DateValueFormatter(dateFormat: getDateFormatDisplay(of: TimeSeriesType(rawValue: sender.selectedSegmentIndex)!))
        chartView.data = chartDataList[sender.selectedSegmentIndex]
        chartView.zoom(scaleX: 0, scaleY: 0, x: 0, y: 0)
    }
    
    private func fetchTimeSeries(of timeSeriesType: TimeSeriesType, completion: @escaping () -> Void) {
        let symbol = self.stock.globalQuote.symbol
        AlphaVantageService.sharedInstance.fetchTimeSeries(of: timeSeriesType, for: symbol) { (timeSeries) in
            if !timeSeries.isEmpty {
                self.timeSeriesList[timeSeriesType.rawValue] = timeSeries
                let chartDataSet = getChartDataSet(of: timeSeriesType, for: timeSeries)
                customizeDataSet(chartDataSet, Float(self.stock.globalQuote.change)!)
                let chartData = LineChartData(dataSet: chartDataSet)
                chartData.setDrawValues(false)
                self.chartDataList[timeSeriesType.rawValue] = chartData
                completion()
            }
        }
    }
    
    init(with stock: StockQuote) {
        self.stock = stock
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func addTapped() {
        print("Favorite Pressed!")
        if stock.isFavorited {
            FirebaseService.sharedInstance.deleteStockFromWatchlist(stockId: stock.id!) {
                self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star")
            }
        } else {
            FirebaseService.sharedInstance.addStockToWatchlist(symbol: stock.globalQuote.symbol, name: stock.name!) { _ in
                self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")
            }
        }
        stock.isFavorited = !stock.isFavorited
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = stock.globalQuote.symbol
        let rightBarButtonImage = stock.isFavorited ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarButtonImage, style: .plain, target: self, action: #selector(addTapped))
        view.backgroundColor = .systemGray6
        
        let chartViewContainer = UIView()
        chartViewContainer.backgroundColor = .white
        chartViewContainer.layer.cornerRadius = 10
        chartViewContainer.addSubview(chartView)
        chartView.anchor(top: chartViewContainer.topAnchor, left: chartViewContainer.leftAnchor, bottom: chartViewContainer.bottomAnchor, right: chartViewContainer.rightAnchor)
        let dashboardView = DashboardView()
        dashboardView.stock = stock
        view.addSubview(dashboardView)
        view.addSubview(chartViewContainer)
        view.addSubview(segmentedControl)

        dashboardView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, padding: .init(top: 15, left: 23, bottom: 0, right: 23), size: .init(width: 344, height: 96))
        chartViewContainer.anchor(top: dashboardView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, padding: .init(top: 14, left: 23, bottom: 0, right: 23), size: .init(width: 344, height: 300))
        segmentedControl.anchor(top: chartViewContainer.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, padding: .init(top: 14, left: 23, bottom: 15, right: 23), size: .init(width: 344, height: 32))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let hourlyChartData = chartDataList[0] {
            self.chartView.data = hourlyChartData
        } else {
            fetchTimeSeries(of: .hourly) {
                self.chartView.data = self.chartDataList[0]
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let root = navigationController?.viewControllers[0] {
            if root is SearchController {
                navigationController?.popToRootViewController(animated: false)
            }
        }
    }
}
