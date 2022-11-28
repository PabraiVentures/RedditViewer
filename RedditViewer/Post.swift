//
//  Post.swift
//  RedditViewer
//
//  Created by Nathan Pabrai on 11/27/22.
//

import Foundation

// TODO: use better property names using Coding Keys to map the names to what is in the Posts repsonse

struct Post: Codable {
    let url: String
    let author: String
    let title: String
    let ups: Int
    let numComments: Int
}
