//
//  StocksModel.swift
//  Stocks
//
//  Created by Daria Ten on 20.09.2021.
// API is free, so call frequency is only 5 calls per minute and 500 calls per day

import Foundation
struct StocksModel {
    let companySymbol: String
    let price: String
    var priceString : String {
        return String(price.dropLast(2))
    }
    var priceChange: String
    var priceChangeString: String {
        return String(priceChange.dropLast(2))
    }
}
