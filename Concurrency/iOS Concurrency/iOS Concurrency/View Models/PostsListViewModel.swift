//
//  PostsListViewModel.swift
//  iOS Concurrency
//
//  Created by Gopal Gurram on 1/10/23.
//

import Foundation

class PostsListViewModel: ObservableObject {
    @Published var posts: [Post] = []
    var userId: Int?
    
    func fetchPosts() {
        guard let userId else { return }
        
        let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users/\(userId)/posts")
        
        apiService.getJSON { (result: Result<[Post], APIError>) in
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
