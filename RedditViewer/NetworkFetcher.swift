//
//  NetworkFetcher.swift
//  RedditViewer
//
//  Created by Nathan Pabrai on 11/27/22.
//

import Foundation
import Kingfisher

enum Subreddit: String, CaseIterable {
    case memes, landscapes
    
    var displayString: String {
        "/r/\(rawValue)"
    }
}

/// For unpacking the Posts from the Subreddit response (reddit.com/memes.json)
struct SubredditResponse: Codable {
    let data: Data
    struct Data: Codable {
        let children: [Child]
        struct Child: Codable {
            let data: Post
        }
    }
}

class NetworkFetcher {
    static let basePostsUrlString = "https://reddit.com/r/"
    var task: URLSessionDataTask?
    func getPostsFor(subreddit: Subreddit, updatingViewModel viewModel: PostsViewModel) {
        task?.cancel()
        if let url = URL(string: "\(Self.basePostsUrlString)\(subreddit.rawValue).json") {
           task = URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                  self.handleResponse(data: data, viewModel: viewModel)
               }
               
               if let error = error {
                   print(error)
                   // TODO: Error handling
               }
           }
           
           task?.resume()
        }
    }
    
    private func handleResponse(data: Data, viewModel: PostsViewModel) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let decoded = try decoder.decode(SubredditResponse.self, from: data)
            let posts = decoded.data.children.map {$0 .data}
            
            // Filter out video posts, this works but theres probably a better way.
            viewModel.posts = posts.filter{ !$0.url.hasPrefix("https://v.redd.it")}
        }
        catch {
            // TODO: Error handling
            print("Error decoding posts")
        }
    }
}
