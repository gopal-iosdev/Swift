//
//  Assets.swift
//  CoffeeShops
//
//  Created by Gopal Gurram on 1/7/23.
//

import Foundation

import UIKit.UIImage

enum ImageAssets: String {
    case envoyLogo = "envoyLogo"
    case coffeePlaceHolder = "coffeePlaceHolder"
    
    var image: UIImage? { UIImage(named: rawValue) }
}
