//
//  TransactionsViewModel.swift
//  TransactionViewer
//
//  Created by Владислав on 02.09.2025.
//

import Foundation

final class TransactionsViewModel {
    
    var titleText: String { "Transactions for \(product.sku)" }
    var onTransactionsUpdated: ((String, [TransactionItem]) -> Void)?

    private let product: Product
    private let service: DataServiceProtocol

    private(set) var headerTotalText: String = "—"
    private(set) var items: [TransactionItem] = []

    private var rates: [CurrencyConversion] = []

    init(product: Product, service: DataServiceProtocol) {
        self.product = product
        self.service = service
    }

    @MainActor
    func loadData() {
        Task {
            rates = await service.fetchRates()

            let gbpSymbol = "GBP".currencySymbol
            var rows: [TransactionItem] = []
            var total: Double = 0

            for transaction in product.transactions {
                let amount = Double(transaction.amount) ?? 0
                let gbp = convert(amount: amount, from: transaction.currency, to: "GBP")
                total += gbp

                let original = String(format: "%@%.2f", transaction.currency.currencySymbol, amount)
                let converted = String(format: "%@%.2f", gbpSymbol, gbp)
                rows.append(TransactionItem(amount: original, convertedAmount: converted))
            }

            headerTotalText = String(format: "Total: %@%.2f", gbpSymbol, total)
            items = rows

            onTransactionsUpdated?(headerTotalText, items)
        }
    }

    private func convert(amount: Double, from sourceCurrency: String, to targetCurrency: String) -> Double {
        if sourceCurrency == targetCurrency { return amount }
        var visitedCurrencies = Set<String>()
        return convertRecursively(
            from: sourceCurrency,
            to: targetCurrency,
            amount: amount,
            visited: &visitedCurrencies
        )
    }

    private func convertRecursively(
        from sourceCurrency: String,
        to targetCurrency: String,
        amount: Double,
        visited: inout Set<String>
    ) -> Double {
        if sourceCurrency == targetCurrency { return amount }
        visited.insert(sourceCurrency)

        if let directRate = rates.first(where: { $0.from == sourceCurrency && $0.to == targetCurrency }) {
            return amount * directRate.rate
        }

        for rate in rates where rate.from == sourceCurrency && !visited.contains(rate.to) {
            let intermediateAmount = amount * rate.rate
            let finalAmount = convertRecursively(
                from: rate.to,
                to: targetCurrency,
                amount: intermediateAmount,
                visited: &visited
            )
            if finalAmount > 0 { return finalAmount }
        }
        return 0
    }

}
