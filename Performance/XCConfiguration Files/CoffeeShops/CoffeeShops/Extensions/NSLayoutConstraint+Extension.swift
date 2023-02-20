//
//  NSLayoutConstraint+Extension.swift
//  CoffeeShops
//
//  Created by Gopal Gurram on 1/7/23.
//

import UIKit.NSLayoutConstraint

extension NSLayoutConstraint {
    class func activateList(_ constraints: [NSLayoutConstraint]...) {
        constraints.forEach(NSLayoutConstraint.activate)
    }
}
