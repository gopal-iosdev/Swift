//
//  API.swift
//  CoffeeShops
//
//  Created by Gopal Gurram on 1/5/23.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

enum HTTPScheme: String {
    case http
    case https
}

protocol API {
    // .http  or .https
    var scheme: HTTPScheme { get }
    // Example: "api.yelp.com"
    var baseURL: String { get }
    // "/v3/businesses/search"
    var path: String { get }
    // [URLQueryItem(name: "latitude", value: "\(shopsInfo.latitude)")]
    var parameters: [URLQueryItem] { get }
    // "GET"
    var method: HTTPMethod { get }
}

