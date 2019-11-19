//
//  NetworkingController.swift
//  Lendr
//
//  Created by Isaac Lyons on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class NetworkingController {
    
    let networkLoader: NetworkDataLoader
    let jsonDecoder = JSONDecoder()
    
    init(networkLoader: NetworkDataLoader = URLSession.shared) {
        self.networkLoader = networkLoader
    }
    
    func fetch<Type: Codable>(from url: URL, completion: @escaping (Type?, Error?) -> Void) {
        networkLoader.loadData(from: url) { data, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError())
                return
            }
            
            do {
                let decodedObject = try self.jsonDecoder.decode(Type.self, from: data)
                completion(decodedObject, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
}
