//
//  UsersListViewModel.swift
//  iOS Concurrency
//
//  Created by Gopal Gurram on 1/10/23.
//

import Foundation

class UsersListViewModel: ObservableObject {
    @Published var usersAndPosts: [UserAndPosts] = []
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var errorMessage: String?
    
    @MainActor
    func fetchUsers() async {
        let usersService = APIService(urlString: "https://jsonplaceholder.typicode.com/users")
        let postsService = APIService(urlString: "https://jsonplaceholder.typicode.com/posts")
        
        isLoading.toggle()
        
        defer {
            isLoading.toggle()
        }
        
        do {
            async let users: [User] = try await usersService.getJSON()
            async let posts: [Post] = try await postsService.getJSON()
            
            let (fetchedUsers, fetchedPosts) = await (try users, try posts)
            
            fetchedUsers.forEach { user in
                let userPosts = fetchedPosts.filter { $0.userId == user.id }
                let newUserAndPosts = UserAndPosts(user: user, posts: userPosts)
                
                usersAndPosts.append(newUserAndPosts)
            }
        } catch {
            showAlert = true
            errorMessage = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to reproduce."
        }
    }
}

extension UsersListViewModel {
    convenience init(forPreview: Bool = false) {
        self.init()

        if forPreview {
            self.usersAndPosts = UserAndPosts.mockUsersAndPosts
        }
    }
}
