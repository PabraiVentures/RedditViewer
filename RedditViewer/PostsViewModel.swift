//
//  PostsViewModel.swift
//  RedditViewer
//
//  Created by Nathan Pabrai on 11/27/22.
//

import Foundation
import Combine

class PostsViewModel: ObservableObject {
    @Published
    var posts: [Post] = []
}
