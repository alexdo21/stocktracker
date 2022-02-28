//
//  ChartsHelper.swift
//  stocktracker
//
//  Created by Alex Do on 2/26/22.
//

import Charts

class DateValueFormatter: NSObject, IAxisValueFormatter {
    let dateFormatter = DateFormatter()
    override init() {
        super.init()
        dateFormatter.dateFormat = getDateFormatDisplay(of: .daily)
    }
    init(dateFormat: String) {
        dateFormatter.dateFormat = dateFormat
    }
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let timeZoneOffset = TimeZone.current.secondsFromGMT()
        let timeZoneEpochOffset = value + Double(timeZoneOffset)
        return dateFormatter.string(from: Date(timeIntervalSince1970: timeZoneEpochOffset))
    }
}

func getChartDataSet(of timeSeriesType: TimeSeriesType, for timeSeries: [String:TimeSeriesSnapshot]) -> LineChartDataSet {
    let sortedDates = timeSeries.keys.sorted().suffix(getDefaultLastDates(of: timeSeriesType))
    let values = sortedDates.compactMap { (dateString) -> ChartDataEntry? in
        if let close = timeSeries[dateString]?.close, let y = Double(close) {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "EST")
            dateFormatter.dateFormat = getDateFormat(of: timeSeriesType)
            if let date = dateFormatter.date(from: dateString) {
                let x = date.timeIntervalSince1970
                return ChartDataEntry(x: x, y: y)
            }
        }
        return nil
    }
    return LineChartDataSet(entries: values, label: "DateSet \(timeSeriesType)")
}

private func getDefaultLastDates(of timeSeriesType: TimeSeriesType) -> Int {
    switch timeSeriesType {
    case .hourly:
        return 12
    case .daily:
        return 30
    case .weekly:
        return 24
    case .monthly:
        return 50
    }
}

private func getDateFormat(of timeSeriesType: TimeSeriesType) -> String {
    switch timeSeriesType {
    case .hourly:
        return "yyyy-MM-dd HH-mm-ss"
    case .daily:
        return "yyyy-MM-dd"
    case .weekly:
        return "yyyy-MM-dd"
    case .monthly:
        return "yyyy-MM-dd"
    }
}

func getDateFormatDisplay(of timeSeriesType: TimeSeriesType) -> String {
    switch timeSeriesType {
    case .hourly:
        return "h:mm a"
    case .daily:
        return "MMM dd"
    case .weekly:
        return "MMM"
    case .monthly:
        return "MMM yyyy"
    }
}
