# Stocktracker

A mobile application that tracks user favorited stock tickers from Alpha Vantage API.

[Click here to watch a demo of Stocktracker](https://www.youtube.com/watch?v=wzaG_p-C9ZY)

The tech stack of Stocktracker is:
- Swift and UIKit with Firebase integration and [Charts](https://github.com/danielgindi/Charts), a library for rendering beautiful charts.
- Firebase NoSQL database.

Relevant repository:
- [Stocktracker](https://github.com/alexdo21/stocktracker)

# Running Locally

1. Clone the repository.
2. Open stocktracker.xcworkspace in Xcode, un a pod install command, and build and run the application for an iPhone 13 Pro target simulator/device.

# Background

Stocktracker (est. 2022) is the first project I built to learn iOS development. I really wanted to get into mobile development and so I decided to go all in by doing a coding challenge from [CodeWithChris](https://www.youtube.com/watch?v=cQtwZhtQPoQ). During this process, I learned a lot about UIKit and how Swift works. I was really surprised how much I liked using Swift. I especially like extensions, built-in optionals, argument labels, enumeration dot syntax and closures.

This app uses the [AlphaVantage API](https://www.alphavantage.co/documentation/) for nearly all of its data and features. Note that AlphaVantage API's free tier, which this app is registered under, only allows 5 API calls per minute. This makes Stocktracker extremely bottlenecked by this rate limit. 

Stocktracker was designed with Figma.

# Technical Details

At its core, Stocktracker is a pretty standard iOS app consisting of a custom UITarBarController as the root view controller with two custom view controllers wrapped in UINavigationViewControllers. It also makes extensive use of UITableViews, custom UITableViewCells and custom views.

More specifically, Stocktracker is separated into two main view controllers: HomeController and SearchController. To share the important global state of user favorited stocks to track, which in the app is called a WatchlistController, both HomeController and SearchController have the same reference to WatchlistController.

## Home Controller

HomeController, as the name suggests, is the main page of the app. This is where the user can view all their favorited stocks and get a preview of each stock ticker's price, price change and hourly chart data. In addition, users are able to perform operations on the resource data including:

- getting all favorited stocks from watchlist
- removing stocks from the watchlist

## Search Controller

SearchController uses AlphaVantage API to allow users to query stock tickers based on ticker symbol and company name. Users are also able to perform operations on the resource data:

- viewing stocks that are already in watchlist in the search results
- adding stocks to watchlist
- removing stocks from watchlist if present in search results

## StockChartController

StockChartController is the detailed view of a stock quote. Users can access this view by clicking on user favorited stocks in HomeControllers and search result matches in SearchController.

Users can view a stock's price, price change, open, high, low, volume. They can also view a chart showing the change in price of the stock over four time series: hourly, daily, weekly and monthly.

StockChartController also allows the user to add and remove a stock from the watchlist.

## Resource Data

Stocktracker's user watchlist data is stored in Firebase's Realtime Database. The schema is defined below:

- user watchlist
    - auto id
        - stock ticker name
        - stock ticker symbol

AlphaVantage API's response is modeled by application model structs. They include:

- StockQuote
- StockSearchResults
- TimeSeriesSnapshot
- HourlyTimeSeries
- DailyTimeSeries
- WeeklyTimeSeries
- MonthlyTimeSeries

# Room For Improvement

- Either upgrade the AlphaVantage API app registration to premium or decouple from the API and implement a cache to store the results of frequent calls.
- Since this was my first iOS app, I would like to go back and refactor to optimize and clean up the code, and incorporate ideas and designs I learned in subsequent projects.
- Add unit / integration tests.
