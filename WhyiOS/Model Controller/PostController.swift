//
//  PostController.swift
//  WhyiOS
//
//  Created by John Tate on 9/5/18.
//  Copyright © 2018 John Tate. All rights reserved.
//

import Foundation

class PostController {
    
    static let shared = PostController()
    
    var posts: [Post] = []
    static let baseURL = URL(string: "https://whydidyouchooseios.firebaseio.com/")
    
    func fetchPosts(completion: @escaping ([Post]?) -> Void) {
        
        guard let url = PostController.baseURL else {
            fatalError("bad base URL")
        }
        
        let requestURL = url.appendingPathComponent("reasons").appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.httpBody = nil
        
        print(request.url?.absoluteString ?? "Nope")
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                print("Error fetching with dataTask \(error) \(error.localizedDescription)")
                completion(nil); return
            }
            
            guard let data = data else { completion(nil); return }
            
            do {
                let jsonDecoder = JSONDecoder()
                let postsDictionary = try jsonDecoder.decode([String:Post].self, from: data)
                let posts = postsDictionary.compactMap({$0.value})
                self.posts = posts
                completion(posts)
            } catch let error {
                print("Error decoding posts \(error) \(error.localizedDescription)")
                completion(nil); return
            }
        }.resume()
    }
    
    func putPost(name: String, reason: String, completion: @escaping (_ success: Bool) -> Void){
        let post = Post(name: name, reason: reason)
        guard let url = PostController.baseURL else {fatalError("bad baseURL")}
        let builtURL = url.appendingPathComponent(post.uuid).appendingPathExtension("json")
        var request = URLRequest(url: builtURL)
        
        let jsonEncoder = JSONEncoder()
        do{
            let data = try jsonEncoder.encode(post)
            request.httpMethod = "PUT"
            request.httpBody = data
        }catch let error {
            print("🤮 Error putting with data task: \(error) \(error.localizedDescription)")
            completion(false); return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("🤮 Error Fetching with data task: \(error) \(error.localizedDescription)")
                completion(false); return
            }
            //for me
            guard let data = data,
                let responseString = String(data: data, encoding: .utf8) else {completion(false); return}
            print(responseString)
            
            //connect the local array to the instances in the cloud or wherever
            PostController.shared.posts.append(post)
            completion(true)
            }.resume()
    }
    
//    func postReason(name: String, reason: String, completion: @escaping (_ success: Bool) -> Void) {
//
//        guard let url = PostController.baseURL?.appendingPathComponent("reasons").appendingPathExtension("json") else {
//            completion(false); return
//        }
//        // Print URL for PUT request
//        print(url)
//
//         let requestURL = url.appendingPathComponent("reasons").appendingPathExtension("json")
//
//        let post = Post(name: name, reason: reason)
//
//        var request = URLRequest(url: requestURL)
//
//        let jsonEncoder = JSONEncoder()
//        do {
//            let data = try jsonEncoder.encode(post)
//            request.httpMethod = "PUT"
//            request.httpBody = data
//        } catch let error {
//            print("Error with JSONEncoder for post: \(error) \(error.localizedDescription)")
//        }
//
//        URLSession.shared.dataTask(with: request) { (data, _, error) in
//
//            if let error = error {
//                print("Error with PUT request: \(error) \(error.localizedDescription)")
//            }
//
//            guard let data = data, let responseString = String(data: data, encoding: .utf8) else { completion(false); return }
//            print(responseString)
//
//            self.posts.append(post)
//            completion(true)
//
//        }.resume()
//    }
}
