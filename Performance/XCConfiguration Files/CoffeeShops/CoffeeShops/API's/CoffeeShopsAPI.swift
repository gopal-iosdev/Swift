//
//  CoffeeShopsAPI.swift
//  CoffeeShops
//
//  Created by Gopal Gurram on 1/5/23.
//

import Foundation

enum Environment: String {
    case secure = "api.yelp.com"
}

enum Endpoint: String {
    case businesses = "/v3/businesses/search"
}

struct BusinessInfo {
    var latitude: Double
    var longitude: Double
    let category: String
    var limit: UInt
    let sortBy: String
    let locale: String
    var offset: UInt
}

enum CoffeeShopsAPI: API {
    
    case getCoffeeShops(environment: Environment, endpoint: Endpoint, shopsInfo: BusinessInfo)
    
    var scheme: HTTPScheme {
        switch self {
        case .getCoffeeShops:
            return .https
        }
    }
    
    var baseURL: String {
        switch self {
        case .getCoffeeShops(let environment, _, _):
            return environment.rawValue
        }
    }
    
    var path: String {
        switch self {
        case .getCoffeeShops(_, let endpoint, _):
            return endpoint.rawValue
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .getCoffeeShops(_, _, let shopsInfo):
            let params = [
                URLQueryItem(name: "latitude", value: "\(shopsInfo.latitude)"),
                URLQueryItem(name: "longitude", value: "\(shopsInfo.longitude)"),
                URLQueryItem(name: "categories", value: shopsInfo.category),
                URLQueryItem(name: "limit", value: "\(shopsInfo.limit)"),
                URLQueryItem(name: "sort_by", value: shopsInfo.sortBy),
                URLQueryItem(name: "locale", value: shopsInfo.locale),
                URLQueryItem(name: "offset", value: "\(shopsInfo.offset)")
            ]
            
            return params
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCoffeeShops:
            return .get
        }
    }
}

