//
//  User.swift
//  iOS Concurrency
//
//  Created by Gopal Gurram on 1/10/23.
//

import Foundation

// Source: https://jsonplaceholder.typicode.com/users

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let userName: String
    let email: String
}
