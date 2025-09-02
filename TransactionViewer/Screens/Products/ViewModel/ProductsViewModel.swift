//
//  ProductsViewModel.swift
//  TransactionViewer
//
//  Created by Владислав on 02.09.2025.
//

import Foundation

final class ProductsViewModel {

    var onItemsUpdated: (([ProductItem]) -> Void)?
    var onErrorMessage: ((String) -> Void)?
    var onNavigateToTransactions: ((Product) -> Void)?

    private let service: DataServiceProtocol
    private var products: [Product] = []
    
    private(set) var items: [ProductItem] = [] { didSet { onItemsUpdated?(items) } }

    init(service: DataServiceProtocol = DataService()) {
        self.service = service
    }

    @MainActor
    func loadData() {
        Task {
            let transactions = await service.fetchTransactions()
            guard !transactions.isEmpty else { onErrorMessage?("Transactions not found"); return }

            var dictionary: [String: [Transaction]] = [:]
            for transaction in transactions { dictionary[transaction.sku, default: []].append(transaction) }
            products = dictionary.map { Product(sku: $0.key, transactions: $0.value) }.sorted { $0.sku < $1.sku }

            items = products.map { .init(title: $0.sku, transactions: "\($0.transactions.count) transactions") }
        }
    }

    func didSelectItem(at index: Int) {
        onNavigateToTransactions?(products[index])
    }
}
