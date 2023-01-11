//
//  MockData.swift
//  iOS Concurrency
//
//  Created by Gopal Gurram on 1/10/23.
//

import Foundation

extension User {
    static var mockUsers: [User] {
        Bundle.main.decode([User].self, from: "Users.json")
    }
    
    static var mockSingleUser: User {
        mockUsers[0]
    }
}

extension Post {
    static var mockPosts: [Post] {
        Bundle.main.decode([Post].self, from: "Posts.json")
    }
    
    static var mockSinglePost: Post {
        mockPosts[0]
    }
    
    static var mockSingleUsersPostArray: [Post] {
        mockPosts.filter({ $0.userId == 1 })
    }
}

extension UserAndPosts {
    static var mockUsersAndPosts: [UserAndPosts] {
        var newUsersAndPosts = [UserAndPosts]()
        User.mockUsers.forEach { user in
            let posts = Post.mockPosts.filter({ $0.userId == user.id })
            let newUserAndPosts = UserAndPosts(user: user, posts: posts)
            
            newUsersAndPosts.append(newUserAndPosts)
        }
        
        return newUsersAndPosts
    }
}
