//
//  APICaller.swift
//  Project-9-NewsApp
//
//  Created by suhail on 22/09/23.
//

import Foundation

final class APICaller{
    
    static let shared = APICaller()
    
    struct Constants{
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=538ccbf843354bdfb6d402f13bae547b")
        static let searchURL = "https://newsapi.org/v2/everything?sortedBy=popularity&apiKey=538ccbf843354bdfb6d402f13bae547b&q="
    }
    //private init() {}
    
    public func getTopStories(completion: @escaping (Result<[Article],Error>)->Void){
        guard let url = Constants.topHeadlinesURL else { return }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error{
                completion(.failure(error))
            }
            else if let data = data{
                do{
                    let result = try JSONDecoder().decode(News.self, from: data)
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
        
    }
    
    public func getSearchedHeadlines(with query: String, completion: @escaping (Result<[Article],Error>)->Void){
        
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        let urlString = Constants.searchURL + query
        
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error{
                completion(.failure(error))
            }
            else if let data = data{
                do{
                    let result = try JSONDecoder().decode(News.self, from: data)
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
        
    }

}


