//
//  PostsListViewModel.swift
//  iOS Concurrency
//
//  Created by Gopal Gurram on 1/10/23.
//

import Foundation

class PostsListViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    var userId: Int?
    
    func fetchPosts() {
        guard let userId else { return }
        
        let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users/\(userId)/posts")
        isLoading.toggle()
        
        apiService.getJSON { (result: Result<[Post], APIError>) in
            defer {
                DispatchQueue.main.async {
                    self.isLoading.toggle()
                }
            }
            
            switch result {
            case .success(let fetchedPosts):
                DispatchQueue.main.async {
                    self.posts = fetchedPosts
                }
            case .failure(let failure):
                dump(failure)
            }
        }
    }
}

extension PostsListViewModel {
    convenience init(forPreview: Bool = false) {
        self.init()
        
        if forPreview {
            self.posts = Post.mockPosts
        }
    }
}