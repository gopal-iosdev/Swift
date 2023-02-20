//
//  BusinessSearchResponse.swift
//  CoffeeShops
//
//  Created by Gopal Gurram on 1/7/23.
//

import Foundation

struct BusinessSearchResponse: Codable {
    let total: UInt
    let businesses: [Business]
}
