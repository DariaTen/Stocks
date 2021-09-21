//
//  StocksService.swift
//  Stocks
//
//  Created by Daria Ten on 20.09.2021.
// API is free, so call frequency is only 5 calls per minute and 500 calls per day

import Foundation

protocol StocksServiceDelegate: AnyObject {
    func didUpdateStocks( _ stocksService: StocksService, stocks: StocksModel)
    
    func didFailWithError(error: Error)
}
protocol StocksServiceProtocol {
    func getStocksPrice(for symbol: String)
}

struct StocksService: StocksServiceProtocol {
    let apiKey = "TC58BGQE9DXS4DPF"
    let baseUrl = "https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol="
    var delegate: StocksServiceDelegate?
    
    func getStocksPrice(for symbol: String) {
        let urlString = "\(baseUrl)\(symbol)&apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    let companies = [
        "Apple": "AAPL",
        "Microsoft": "MSFT",
        "Google": "GOOG",
        "Amazon": "AMZN",
        "IBM": "IBM",
        "Facebook": "FB"
    ]
    
    private func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let stocks = self.parseJSON(safeData) {
                        delegate?.didUpdateStocks(self, stocks: stocks)
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJSON(_ data: Data) -> StocksModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(StocksData.self, from: data)
            let companySymbol = decodedData.globalQuote.companySymbol
            let price = decodedData.globalQuote.price
            let priceChange = decodedData.globalQuote.priceChange
            let stocks = StocksModel(companySymbol: companySymbol, price: price, priceChange: priceChange)
            return stocks
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
