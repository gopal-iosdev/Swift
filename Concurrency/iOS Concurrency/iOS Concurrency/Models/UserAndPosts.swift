//
//  UserAndPosts.swift
//  iOS Concurrency
//
//  Created by Gopal Gurram on 1/11/23.
//

import Foundation

struct UserAndPosts: Identifiable {
    var id = UUID()
    let user: User
    let posts: [Post]
    var numberOfPosts: Int {
        posts.count
    }
}
