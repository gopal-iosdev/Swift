//
//  AppEnvironment.swift
//  CoffeeShops
//
//  Created by Gopal Gurram on 2/19/23.
//

import Foundation

public struct AppEnvironment {
    enum Keys {
        static let apiKey = "API_KEY"
    }
    
    // Get the API_KEY
    static let apiKey: String = {
        guard let apiKeyProperty = Bundle.main.object(
            forInfoDictionaryKey: Keys.apiKey
        ) as? String else {
            fatalError("API_KEY not found")
        }
        
        return apiKeyProperty
    }()
}
