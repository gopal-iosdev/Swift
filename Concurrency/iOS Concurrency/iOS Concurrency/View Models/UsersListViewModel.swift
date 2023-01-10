//
//  UsersListViewModel.swift
//  iOS Concurrency
//
//  Created by Gopal Gurram on 1/10/23.
//

import Foundation

class UsersListViewModel: ObservableObject {
    @Published var users: [User] = []
    
    func fetchUsers() {
        let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users")
        
        apiService.getJSON { (result: Result<[User], APIError>) in
            switch result {
            case .success(let fetchedUsers):
                DispatchQueue.main.async {
                    self.users = fetchedUsers
                }
            case .failure(let failure):
                dump(failure)
            }
        }
    }
}

extension UsersListViewModel {
    convenience init(forPreview: Bool = false) {
        self.init()
        
        if forPreview {
            self.users = User.mockUsers
        }
    }
}
