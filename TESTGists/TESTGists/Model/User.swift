//
//  User.swift
//  TESTGists
//
//  Created by Serhii Ostrovetskyi on 8/21/19.
//  Copyright © 2019 dev. All rights reserved.
//

import Foundation

struct User: Decodable {
    var login: String
    var avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
}

extension User {
    init() {
        login = ""
        avatarUrl = ""
    }
    
    init(from decoder: Decoder) throws {
        let userContainer = try decoder.container(keyedBy: CodingKeys.self)
        login = try userContainer.decode(String.self, forKey: .login)
        avatarUrl = try userContainer.decode(String.self, forKey: .avatarUrl)
        
    }
}
