//
//  NetworkingController.swift
//  Lendr
//
//  Created by Isaac Lyons on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

enum HeaderNames: String {
    case auth = "Authorization"
    case contentType = "Content-Type"
}

class NetworkingController {
    
    let baseURL = URL(string: "https://zero5nelsonm-lendr.herokuapp.com")!
    let networkLoader: NetworkDataLoader
    let jsonDecoder = JSONDecoder()
    
    #warning("Remove the default access token once login is supported")
    var bearer: Bearer? = Bearer(accessToken: "28dd42cf-1468-4baa-b1dc-0d55b647044c")
    
    init(networkLoader: NetworkDataLoader = URLSession.shared) {
        self.networkLoader = networkLoader
    }
    
    func fetch<Type: Codable>(from url: URL, completion: @escaping (Type?, Error?) -> Void) {
        guard let bearer = bearer else {
            completion(nil, NSError())
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(bearer.accessToken)", forHTTPHeaderField: HeaderNames.auth.rawValue)
        
        networkLoader.loadData(with: request) { data, error in
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
