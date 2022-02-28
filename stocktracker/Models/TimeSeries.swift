//
//  TimeSeries.swift
//  stocktracker
//
//  Created by Alex Do on 2/25/22.
//

import UIKit

enum TimeSeriesType: Int {
    case hourly
    case daily
    case weekly
    case monthly
}

struct TimeSeriesSnapshot: Codable {
    let open, high, low, close, volume: String
    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
        case close = "4. close"
        case volume = "5. volume"
    }
}

struct MetaData: Codable {
    let lastRefreshed: String
    enum CodingKeys: String, CodingKey {
        case lastRefreshed = "3. Last Refreshed"
    }
}

struct HourlyTimeSeries: Codable {
    let metaData: MetaData
    let timeSeries: [String: TimeSeriesSnapshot]
    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeries = "Time Series (60min)"
    }
}

struct DailyTimeSeries: Codable {
    let metaData: MetaData
    let timeSeries: [String: TimeSeriesSnapshot]
    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeries = "Time Series (Daily)"
    }
}

struct WeeklyTimeSeries: Codable {
    let metaData: MetaData
    let timeSeries: [String: TimeSeriesSnapshot]
    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeries = "Weekly Time Series"
    }
}

struct MonthlyTimeSeries: Codable {
    let metaData: MetaData
    let timeSeries: [String: TimeSeriesSnapshot]
    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeries = "Monthly Time Series"
    }
}
