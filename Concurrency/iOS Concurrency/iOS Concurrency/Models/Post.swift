//
//  Post.swift
//  iOS Concurrency
//
//  Created by Gopal Gurram on 1/10/23.
//

import Foundation

// Source: https://jsonplaceholder.typicode.com/posts

// Single User Posts: https://jsonplaceholder.typicode.com/users/1/posts

struct Post: Codable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
