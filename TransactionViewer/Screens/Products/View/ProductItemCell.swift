//
//  ProductItemCell.swift
//  TransactionViewer
//
//  Created by Владислав on 02.09.2025.
//

import UIKit

final class ProductItemCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ProductItemCell"
    
    private let chevronImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tintColor = .systemGray
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "chevron.right")
        
        return $0
    }(UIImageView())
    
    private let transactionCountLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.textColor = .systemGray
        $0.adjustsFontForContentSizeCategory = true

        return $0
    }(UILabel())
    
    private let productTitleLabel: UILabel = {
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
    
    func configure(_ product: ProductItem) {
        productTitleLabel.text = product.title
        transactionCountLabel.text = product.transactions
    }
    
    private func setupViews() {
        contentView.addSubview(productTitleLabel)
        contentView.addSubview(transactionCountLabel)
        contentView.addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            productTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            transactionCountLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            transactionCountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 20),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
