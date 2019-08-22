//
//  ApiClientError.swift
//  TESTGists
//
//  Created by Serhii Ostrovetskyi on 8/21/19.
//  Copyright © 2019 dev. All rights reserved.
//

import Foundation

enum ApiClientError: LocalizedError {
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case .unknownError:
            return "Something happened. Try again later"
        }
    }
}
