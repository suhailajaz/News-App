//
//  News.swift
//  Project-9-NewsApp
//
//  Created by suhail on 22/09/23.
//

import Foundation

struct News: Codable{
    var articles: [Article]
}

struct Article: Codable{
    var source: Source
    var author: String?
    var title: String
    var description: String?
    var url: String
    var urlToImage: String?
    var publishedAt: String?
    var content : String?
    
}

struct Source: Codable{
    var id:String?
    var name: String
}
