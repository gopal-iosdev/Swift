//
//  BusinessListCollectionViewFlowLayout.swift
//  CoffeeShops
//
//  Created by Gopal Gurram on 1/8/23.
//

import UIKit

class BusinessListCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private var itemsInRow: CGFloat {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        // 2. check the idiom
        switch (deviceIdiom) {
        case .pad:
            return 3
        case .phone:
            return UIDevice.current.orientation.isLandscape ? 3 : 2
        default:
            return 2
        }
    }
    
    init(in parentView: UIView) {
        super.init()
        
        let width = parentView.bounds.width
        let padding: CGFloat = 12
        let minItemSpacing: CGFloat = 10
        let availableWidth = width - (2 * padding) - (2 * minItemSpacing)
        let itemWidth = floor(availableWidth / itemsInRow)
        
        self.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        self.itemSize = CGSize(width: itemWidth, height: (itemWidth + 40))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

