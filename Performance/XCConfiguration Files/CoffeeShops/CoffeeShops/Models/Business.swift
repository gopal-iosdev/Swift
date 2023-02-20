//
//  Business.swift
//  CoffeeShops
//
//  Created by Gopal Gurram on 1/7/23.
//

import Foundation

struct Coordinates: Codable {
    let latitude: Double
    let longitude: Double
}

enum Price: String, Codable {
    case low = "$"
    case medium = "$$"
    case high = "$$$"
    case veryHigh = "$$$$"
}

struct Address: Codable {
    let city: String
    let country: String
    let state: String
    let street: String
    let zipCode: String
    
    enum CodingKeys: String, CodingKey {
        case city, country, state, zipCode
        case street = "address1"
    }
}

struct Business: Codable, Hashable {
    static func == (lhs: Business, rhs: Business) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    let name: String
    let imageUrl: String
    let address: Address
    let rating: Double
    let price: Price?
    let phone: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, rating, phone, price, imageUrl
        case address = "location"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
}
