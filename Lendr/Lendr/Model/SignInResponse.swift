//
//  SignInResponse.swift
//  Lendr
//
//  Created by Isaac Lyons on 11/21/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct SignInResponse: Codable {
    let accessToken: String

    enum ResponseKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}

extension SignInResponse {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResponseKeys.self)

        accessToken = try container.decode(String.self, forKey: .accessToken)
    }
}
