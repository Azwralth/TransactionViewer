//
//  TransactionHeaderView.swift
//  TransactionViewer
//
//  Created by Владислав on 02.09.2025.
//

import UIKit

final class TransactionHeaderView: UICollectionReusableView {

    static let reuseIdentifier = "TransactionHeaderView"

    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        $0.font = UIFont.preferredFont(forTextStyle: .headline)
        $0.adjustsFontForContentSizeCategory = true
        
        return $0
    }(UILabel())

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(text: String) {
        titleLabel.text = text
    }

    private func setupViews() {
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
