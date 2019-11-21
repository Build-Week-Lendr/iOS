//
//  NetworkDataLoader.swift
//  Lendr
//
//  Created by Isaac Lyons on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

protocol NetworkDataLoader {
    func loadData(with request: URLRequest, completion: @escaping (Data?, Error?) -> Void)
    func loadData(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
    func loadData(from url: URL, completion: @escaping( Data?, Error?) -> Void)
}
