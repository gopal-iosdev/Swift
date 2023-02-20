//
//  CoffeeShopsDataSource.swift
//  CoffeeShops
//
//  Created by Gopal Gurram on 1/8/23.
//

import UIKit

class CoffeeShopsDataSource: NSObject, UICollectionViewDataSource,  UICollectionViewDataSourcePrefetching {
    
    let viewModel: CoffeeShopsViewModel
    let imageLoader: ImageLoader
    
    init(viewModel: CoffeeShopsViewModel, imageLoader: ImageLoader) {
        self.viewModel = viewModel
        self.imageLoader = imageLoader
    }
    
    convenience init(viewModel: CoffeeShopsViewModel) {
        self.init(viewModel: viewModel,
                  imageLoader: ImageLoadManager())
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.coffeeShopsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BusinessInfoCVCell.reUsableID, for: indexPath) as! BusinessInfoCVCell
        
        self.configure(cell, for: indexPath)
        
        return cell
    }
    
    // MARK: - UICollectionViewDataSourcePrefetching
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if indexPath.row == viewModel.coffeeShopsCount - 2 {
                //last restaurant available in model -> fetch next page
                viewModel.fetchNextPage()
            }
            
            let imageURL = viewModel.coffeeShopRating(for: indexPath)
            imageLoader.loadImage(from: imageURL) {_ in }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let imageUrl = viewModel.coffeeShopRating(for: indexPath)
            imageLoader.cancelLoadImage(url: imageUrl)
        }
    }
    
    private func configure(_ cell: BusinessInfoCVCell, for indexPath: IndexPath) {
        cell.nameLabel.text = self.viewModel.coffeeShopName(for: indexPath)
        cell.addressLabel.text = self.viewModel.coffeeShopAddress(for: indexPath)
        cell.priceLabel.text = self.viewModel.coffeeShopPrice(for: indexPath)
        cell.reviewLabel.text = self.viewModel.coffeeShopRating(for: indexPath)
        let imageUrl = self.viewModel.coffeeShopImageUrl(for: indexPath)
        
        imageLoader.loadImage(from: imageUrl) { [weak cell] (image) in
            cell?.avatarImageView.image = image ?? ImageAssets.coffeePlaceHolder.image
        }
        
        cell.prepareToReuse = { [weak self] in
            self?.imageLoader.cancelLoadImage(url: imageUrl)
        }
    }
}

