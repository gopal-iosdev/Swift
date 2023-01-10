//
//  PostsListView.swift
//  iOS Concurrency
//
//  Created by Gopal Gurram on 1/10/23.
//

import SwiftUI

struct PostsListView: View {
    @State var vm: PostsListViewModel = PostsListViewModel(forPreview: true)
    var userId: Int?
    
    var body: some View {
        List {
            ForEach(vm.posts) { post in
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.headline)
                    Text(post.body)
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Posts")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)
        .onAppear {
            vm.userId = userId
            vm.fetchPosts()
        }
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PostsListView(userId: 1)
        }
    }
}
