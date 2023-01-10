//
//  UsersListView.swift
//  iOS Concurrency
//
//  Created by Gopal Gurram on 1/10/23.
//

import SwiftUI

struct UsersListView: View {
    #warning("remove the forPreview argument or set it to false before uploading to App store")
    @StateObject var vm = UsersListViewModel(forPreview: true)
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.users) { user in
                    NavigationLink {
                        PostsListView(userId: user.id)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(user.name)
                                .font(.title)
                            Text(user.email)
                        }
                    }
                }
            }
            .navigationTitle("Users")
            .listStyle(.plain)
            .onAppear {
                vm.fetchUsers()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        UsersListView()
    }
}
