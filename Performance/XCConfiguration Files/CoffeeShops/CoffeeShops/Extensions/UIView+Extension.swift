//
//  UIView+Extension.swift
//  CoffeeShops
//
//  Created by Gopal Gurram on 1/7/23.
//

import UIKit.UIView

extension UIView {
    func addSubViews(_ views: UIView...) {
        views.forEach(addSubview)
    }
}
