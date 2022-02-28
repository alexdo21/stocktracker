//
//  StockChartController.swift
//  stocktracker
//
//  Created by Alex Do on 2/14/22.
//

import UIKit
import Charts

class StockChartController : UIViewController {
    var stock: StockQuote {
        didSet {
        }
    }
    
    var hourly: [String: TimeSeriesSnapshot]?
    var daily: [String: TimeSeriesSnapshot]?
    var weekly: [String: TimeSeriesSnapshot]?
    var monthly: [String: TimeSeriesSnapshot]?

    var chartDataList = [LineChartData?](repeating: nil, count: 4)
    var timeSeriesList = [[String:TimeSeriesSnapshot]?](repeating: nil, count: 4)
    
    let dashboardView: UIView = {
        let dv = UIView()
        dv.backgroundColor = .systemYellow
        return dv
    }()
    lazy var chartView: LineChartView = {
        let cv = LineChartView()
        cv.backgroundColor = .systemGray5
        
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
        
        cv.animate(xAxisDuration: 3.5)
        
        return cv
    }()
    lazy var segmentedControl: UISegmentedControl = {
        let items = ["1H", "1D", "1W", "1M"]
        let sc = UISegmentedControl(items: items)
        sc.selectedSegmentIndex = 1
        sc.backgroundColor = .systemYellow
        sc.addTarget(self, action: #selector(handleSelect), for: .valueChanged)
        return sc
    }()
    
    @objc private func handleSelect(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 && hourly == nil {
            fetchTimeSeries(of: .hourly) { self.chartView.data = self.chartDataList[0] }
        } else if sender.selectedSegmentIndex == 1 && daily == nil {
            fetchTimeSeries(of: .daily) { self.chartView.data = self.chartDataList[1] }
        } else if sender.selectedSegmentIndex == 2 && weekly == nil {
            fetchTimeSeries(of: .weekly) { self.chartView.data = self.chartDataList[2] }
        } else if sender.selectedSegmentIndex == 3 && monthly == nil {
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
                let colors = chartDataSet.entries.map { (entry) -> UIColor in
                    return entry.y >= self.chartView.leftAxis.limitLines[0].limit ? .systemGreen : .systemRed
                }
                chartDataSet.drawCirclesEnabled = false
                chartDataSet.lineWidth = 3
                chartDataSet.valueColors = colors
                chartDataSet.mode = .cubicBezier
                
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = stock.globalQuote.symbol
        view.backgroundColor = .systemGray6
        
        view.addSubview(dashboardView)
        view.addSubview(chartView)
        view.addSubview(segmentedControl)
        
        fetchTimeSeries(of: .daily) {
            self.chartView.data = self.chartDataList[1]
        }
        
        dashboardView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, padding: .init(top: 15, left: 23, bottom: 0, right: 23), size: .init(width: 344, height: 96))
        chartView.anchor(top: dashboardView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, padding: .init(top: 14, left: 23, bottom: 0, right: 23), size: .init(width: 344, height: 300))
        segmentedControl.anchor(top: chartView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, padding: .init(top: 14, left: 23, bottom: 15, right: 23), size: .init(width: 344, height: 32))
    }
}
