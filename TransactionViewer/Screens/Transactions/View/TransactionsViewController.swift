//
//  TransactionsViewController.swift
//  TransactionViewer
//
//  Created by Владислав on 02.09.2025.
//

import UIKit

final class TransactionsViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.headerMode = .supplementary
        configuration.showsSeparators = true
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private let viewModel: TransactionsViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Section, TransactionItem>!
    
    init(viewModel: TransactionsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        setupUI()
        configureDataSource()
        
        bindViewModel()
        
        viewModel.loadData()
        
        title = viewModel.titleText
    }

    private func bindViewModel() {
        viewModel.onTransactionsUpdated = { [weak self] header, items in
            self?.updateHeader(header)
            self?.updateTransactions(items)
        }
    }
}

// MARK: - UI
private extension TransactionsViewController {
    
    func setupUI() {
        view.addSubview(collectionView)
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureCollectionView() {
        collectionView.register(TransactionItemCell.self, forCellWithReuseIdentifier: TransactionItemCell.reuseIdentifier)
    }
}

// MARK: - DataSource
private extension TransactionsViewController {
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, TransactionItem>(
            collectionView: collectionView
        ) { cv, indexPath, vm in
            guard let cell = cv.dequeueReusableCell(
                withReuseIdentifier: TransactionItemCell.reuseIdentifier,
                for: indexPath
            ) as? TransactionItemCell else { return UICollectionViewCell() }
            cell.configure(vm)
            return cell
        }
    }
    
    func updateHeader(_ title: String) {
        let headerReg = UICollectionView.SupplementaryRegistration<TransactionHeaderView>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { (headerView, _ , _ ) in
            headerView.configure(text: title)
        }
        
        dataSource.supplementaryViewProvider = { (
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath
        ) -> UICollectionReusableView? in
            collectionView.dequeueConfiguredReusableSupplementary(using: headerReg, for: indexPath)
        }
    }
    
    func updateTransactions(_ items: [TransactionItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, TransactionItem>()
        snapshot.appendSections([.transactions])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
