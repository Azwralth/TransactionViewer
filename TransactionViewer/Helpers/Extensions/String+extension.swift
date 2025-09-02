//
//  String+extension.swift
//  TransactionViewer
//
//  Created by Владислав on 02.09.2025.
//

import Foundation

extension String {
    var currencySymbol: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = self
        return formatter.currencySymbol ?? self
    }
}
