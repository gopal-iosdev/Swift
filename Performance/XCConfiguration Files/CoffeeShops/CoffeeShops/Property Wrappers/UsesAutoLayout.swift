//
//  UsesAutoLayout.swift
//  CoffeeShops
//
//  Created by Gopal Gurram on 2/2/23.
//

import UIKit

@propertyWrapper
public struct UsesAutoLayout<T: UIView> {
    public var wrappedValue: T {
        didSet {
            setTranslatesAutoresizingMaskIntoConstraints()
        }
    }
    
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        setTranslatesAutoresizingMaskIntoConstraints()
    }
    
    private func setTranslatesAutoresizingMaskIntoConstraints() {
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
    }
}
