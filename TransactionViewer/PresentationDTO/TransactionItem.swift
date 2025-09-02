//
//  TransactionItem.swift
//  TransactionViewer
//
//  Created by Владислав on 02.09.2025.
//

import Foundation

struct TransactionItem: Hashable, Identifiable {
    let id = UUID()
    let amount: String
    let convertedAmount: String
}
