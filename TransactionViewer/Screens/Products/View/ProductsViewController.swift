//
//  ProductsViewController 2.swift
//  TransactionViewer
//
//  Created by Владислав on 02.09.2025.
//


import UIKit

final class ProductsViewController: UIViewController {

    private let collectionView: UICollectionView = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()

    private let viewModel: ProductsViewModel
    private var dataSource: UICollectionViewDiffableDataSource<Section, ProductItem>!
 
    init(viewModel: ProductsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureDataSource()
        
        setupUI()
        
        bindViewModel()
        viewModel.loadData()
        
        title = "Products"
    }
    
    private func bindViewModel() {
        viewModel.onItemsUpdated = { [weak self] items in self?.updateProducts(items) }
        viewModel.onErrorMessage = { [weak self] message in
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
        viewModel.onNavigateToTransactions = { [weak self] product in
            let viewModel = TransactionsViewModel(product: product, service: DataService())
            let vc = TransactionsViewController(viewModel: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension ProductsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        viewModel.didSelectItem(at: indexPath.item)
    }
}

// MARK: - UICollectionViewDiffableDataSource
private extension ProductsViewController {
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, ProductItem>(
            collectionView: collectionView
        ) { cv, indexPath, product in
            guard let cell = cv.dequeueReusableCell(withReuseIdentifier: ProductItemCell.reuseIdentifier, for: indexPath)
                    as? ProductItemCell else { return UICollectionViewCell() }
            cell.configure(product)
            return cell
        }
    }
    
    func updateProducts(_ products: [ProductItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductItem>()
        snapshot.appendSections([.products])
        snapshot.appendItems(products)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UI
private extension ProductsViewController {
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.register(ProductItemCell.self, forCellWithReuseIdentifier: ProductItemCell.reuseIdentifier)
    }
}
