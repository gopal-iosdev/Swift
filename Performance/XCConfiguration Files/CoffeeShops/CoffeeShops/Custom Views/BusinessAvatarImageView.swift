//
//  BusinessAvatarImageView.swift
//  CoffeeShops
//
//  Created by Gopal Gurram on 1/8/23.
//

import UIKit.UIImageView

class BusinessAvatarImageView: UIImageView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
