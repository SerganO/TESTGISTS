//
//  Gist.swift
//  TESTGists
//
//  Created by Serhii Ostrovetskyi on 8/21/19.
//  Copyright © 2019 dev. All rights reserved.
//

import Foundation

struct Gist: Decodable, Equatable {
    var description: String
    var owner: User
    
    enum CodingKeys: String, CodingKey {
        case owner
        case description
    }
}

extension Gist {
    init() {
        description = ""
        owner = User()
    }
    
    init(from decoder: Decoder) throws {
        let userContainer = try decoder.container(keyedBy: CodingKeys.self)
        owner = try userContainer.decode(User.self, forKey: .owner)
        if let _description = try? userContainer.decode(String.self, forKey: .description) {
            description = _description
        } else {
            description = ""
        }
        
    }
}


