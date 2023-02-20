//
//  CoffeeShopsDirectoryVC.swift
//  CoffeeShops
//
//  Created by Gopal Gurram on 1/5/23.
//

import UIKit

class CoffeeShopsDirectoryVC: UIViewController, Loadable {
    var viewModel: CoffeeShopsViewModel
    var containerView: UIView?
    
    private var dataSource: UICollectionViewDataSource & UICollectionViewDataSourcePrefetching
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: BusinessListCollectionViewFlowLayout(in: view))
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = dataSource
        collectionView.prefetchDataSource = dataSource
        collectionView.register(BusinessInfoCVCell.self, forCellWithReuseIdentifier: BusinessInfoCVCell.reUsableID)
        
        return collectionView
    }()
    
    init(viewModel: CoffeeShopsViewModel, dataSource: UICollectionViewDataSource & UICollectionViewDataSourcePrefetching) {
        self.viewModel = viewModel
        self.dataSource = dataSource
        
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        let viewModel = CoffeeShopsViewModel()
        self.init(viewModel: viewModel, dataSource: CoffeeShopsDataSource(viewModel: viewModel))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.title

        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(collectionView)
        
        
        viewModel.updateUI = { [unowned self] in
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
        viewModel.fetchCoffeeShops()
        
        updateUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionView.frame = view.bounds
        collectionView.collectionViewLayout = BusinessListCollectionViewFlowLayout(in: view)
        collectionView.reloadData()
    }
    
    private func updateUI() {
        switch viewModel.viewState {
        case .loading:
            showLoadingView()
        case .error:
            hideLoadingView()
            showAlert()
        case .emptyState:
            hideLoadingView()
            showEmptyStateView(with: viewModel.emptyStateInfoMessage, in: view)
        case .updatesAvailable:
            hideLoadingView()
            collectionView.reloadData()
        }
    }
}

extension CoffeeShopsDirectoryVC {
    private func showAlert() {
        let alertController = UIAlertController(title: viewModel.alertTitle, message: viewModel.alertMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: viewModel.okString, style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}
