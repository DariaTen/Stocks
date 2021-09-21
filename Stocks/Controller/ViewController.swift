//
//  ViewController.swift
//  Stocks
//
//  Created by Daria Ten on 22.08.2021.
// API is free, so call frequency is only 5 calls per minute and 500 calls per day

import UIKit

class ViewController: UIViewController {
    
	@IBOutlet weak var companyLabelName: UILabel!
	@IBOutlet weak var companyPickerView: UIPickerView!
	@IBOutlet weak var companySymbolLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var priceChangeLabel: UILabel!
    
    var stocksService = StocksService()
    
// MARK: - Lifecycle
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
		companyPickerView.dataSource = self
		companyPickerView.delegate = self
        stocksService.delegate = self
	}
}
// MARK: - UIPickerViewDataSource, UIPickerViewDelegate

extension ViewController : UIPickerViewDataSource, UIPickerViewDelegate  {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stocksService.companies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(stocksService.companies.keys)[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCompany = Array(stocksService.companies.values)[row]
        stocksService.getStocksPrice(for: selectedCompany)
        self.companyLabelName.text = Array(stocksService.companies.keys)[row]
    }
}
// MARK: - StocksServiceDelegate

extension ViewController : StocksServiceDelegate {
    func didUpdateStocks(_ stocksService: StocksService, stocks: StocksModel) {
        DispatchQueue.main.async {
            self.companySymbolLabel.text = stocks.companySymbol
            self.priceLabel.text = stocks.priceString
            self.priceChangeLabel.text = stocks.priceChangeString
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

