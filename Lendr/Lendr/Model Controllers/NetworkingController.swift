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
    let jsonEncoder = JSONEncoder()
    
    var bearer: Bearer? = Bearer(accessToken: "71ae686c-e5e7-432d-b0aa-65f0d96dc2a3")
    
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
    
    func signUp(user: SignUpUser, completion: @escaping (SignInResponse?, Error?) -> Void) {
        let url = baseURL.appendingPathComponent("createnewuser")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
        
        do {
            let encodedUser = try jsonEncoder.encode(user)
            request.httpBody = encodedUser
        } catch {
            completion(nil, error)
        }
        
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
                let signInResponse = try self.jsonDecoder.decode(SignInResponse.self, from: data)
                completion(signInResponse, nil)
            } catch {
                completion(nil, error)
            }
        }
    }
    
    func signIn(token: String) {
        bearer = Bearer(accessToken: token)
    }
    
    func post<Type: Codable>(_ value: Type, to url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let bearer = bearer else {
            completion(nil, nil, NSError())
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(bearer.accessToken)", forHTTPHeaderField: HeaderNames.auth.rawValue)
        request.setValue("application/json", forHTTPHeaderField: HeaderNames.contentType.rawValue)
        
        do {
            let encodedJSON = try jsonEncoder.encode(value)
            request.httpBody = encodedJSON
        } catch {
            completion(nil, nil, error)
            return
        }
        
        networkLoader.loadData(with: request) { data, response, error in
            if let error = error {
                completion(nil, nil, error)
                return
            }
            
            guard let data = data,
                let response = response else {
                completion(nil, nil, NSError())
                return
            }
            
            completion(data, response, nil)
        }
    }
    
    func delete(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let bearer = bearer else {
            completion(nil, nil, NSError())
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(bearer.accessToken)", forHTTPHeaderField: HeaderNames.auth.rawValue)
        
        networkLoader.loadData(with: request, completion: completion)
    }
    
}
