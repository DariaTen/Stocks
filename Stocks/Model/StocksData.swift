//
//  StocksData.swift
//  Stocks
//
//  Created by Daria Ten on 20.09.2021.
// API is free, so call frequency is only 5 calls per minute and 500 calls per day

import Foundation

struct StocksData: Codable {
    let globalQuote : GlobalQuote
    enum CodingKeys: String, CodingKey {
    case globalQuote = "Global Quote"
    }
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
        self.globalQuote = try container.decode(GlobalQuote.self, forKey: .globalQuote)
        }
    
struct GlobalQuote: Codable {
    let companySymbol: String
    let price: String
    let priceChange: String
    enum CodingKeys: String, CodingKey {
        case companySymbol = "01. symbol"
        case price = "05. price"
        case priceChange = "09. change"
    }
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.companySymbol = try container.decode(String.self, forKey: .companySymbol)
            self.price = try container.decode(String.self, forKey: .price)
            self.priceChange = try container.decode(String.self, forKey: .priceChange)
    }
}
}
