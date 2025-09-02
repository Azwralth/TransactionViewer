//
//  TransactionItemCell.swift
//  TransactionViewer
//
//  Created by Владислав on 02.09.2025.
//

import UIKit

final class TransactionItemCell: UICollectionViewCell {

    static let reuseIdentifier = "TransactionItemCell"
    
    private let convertedAmountLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.adjustsFontForContentSizeCategory = true
        $0.textColor = .systemGray
        
        return $0
    }(UILabel())

    private let originalAmountLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.adjustsFontForContentSizeCategory = true

        return $0
    }(UILabel())

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ transaction: TransactionItem) {
        originalAmountLabel.text = transaction.amount
        convertedAmountLabel.text = transaction.convertedAmount
    }

    private func setupViews() {
        contentView.backgroundColor = .white
        contentView.addSubview(originalAmountLabel)
        contentView.addSubview(convertedAmountLabel)

        NSLayoutConstraint.activate([
            originalAmountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            originalAmountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            convertedAmountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            convertedAmountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
