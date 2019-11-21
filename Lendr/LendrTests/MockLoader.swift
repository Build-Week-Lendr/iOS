//
//  MockLoader.swift
//  LendrTests
//
//  Created by Isaac Lyons on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
@testable import Lendr

class MockLoader: NetworkDataLoader {
    
    var request: URLRequest?
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func loadData(with request: URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        self.request = request
        DispatchQueue.main.async {
            completion(self.data, self.error)
        }
    }
    
    func loadData(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.request = request
        DispatchQueue.main.async {
            completion(self.data, self.response, self.error)
        }
    }
    
    func loadData(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        self.request = URLRequest(url: url)
        DispatchQueue.main.async {
            completion(self.data, self.error)
        }
    }
    
}
