//
//  DataMapper.swift
//  TransactionViewer
//
//  Created by Владислав on 02.09.2025.
//

import Foundation

protocol DataServiceProtocol {
    func fetchTransactions() async -> [Transaction]
    func fetchRates() async -> [CurrencyConversion]
}

final class DataService: DataServiceProtocol {

    func fetchTransactions() async -> [Transaction] {
        guard let path = Bundle.main.path(forResource: "transactions", ofType: "plist"),
              let array = NSArray(contentsOfFile: path) as? [[String: String]] else {
            return []
        }

        return array.compactMap { dictionary in
            guard let currency = dictionary["currency"],
                  let amount = dictionary["amount"],
                  let sku = dictionary["sku"] else { return nil }
            
            return Transaction(amount: amount, currency: currency, sku: sku)
        }
    }
    
    func fetchRates() async -> [CurrencyConversion] {
        guard let path = Bundle.main.path(forResource: "rates", ofType: "plist"),
              let array = NSArray(contentsOfFile: path) as? [[String: String]] else {
            return []
        }
        
        return array.compactMap { dictionary in
            guard let rateStr = dictionary["rate"],
                  let rate = Double(rateStr),
                  let from = dictionary["from"],
                  let to = dictionary["to"] else { return nil }
            
            return CurrencyConversion(from: from, rate: rate, to: to)
        }
    }
}
