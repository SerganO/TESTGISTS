//
//  ApiRouter.swift
//  TESTGists
//
//  Created by Serhii Ostrovetskyi on 8/21/19.
//  Copyright © 2019 dev. All rights reserved.
//

import Foundation
import Alamofire

enum ApiRouter: URLRequestConvertible {
    
    private static let baseUrl = "https://api.github.com"
    private static var authorizationString = ""
    case login(username: String, password: String)
    case getGistsForPage(page: Int, isPublic: Bool)
    case createGistWith(description: String, isPublic: Bool, files:[GistFile])
    
    var method: HTTPMethod {
        switch self {
        case .login,
             .getGistsForPage:
            return .get
        case .createGistWith:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/user"
        case .getGistsForPage(_, let isPublic):
            if isPublic {
                return "/gists/public"
            } else {
                return "/gists"
            }
        case .createGistWith:
            return "/gists"
        }
    }
    
    var defaultHeaders: HTTPHeaders {
        return ["Content-Type":"application/json","Accept": "application/json"]
    }
    
    
    var authHeaders: HTTPHeaders {
        var headers = defaultHeaders
        if ApiRouter.authorizationString != "" {
            headers["authorization"] = "Basic " + ApiRouter.authorizationString
        }
        return headers
    }

    func asURLRequest() throws -> URLRequest {
        
        let url = try ApiRouter.baseUrl.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = defaultHeaders

        switch self {
        case .login(username:let username, password: let password):
            ApiRouter.authorizationString = "\(username):\(password)".toBase64()
            urlRequest.allHTTPHeaderFields = authHeaders
        case .getGistsForPage(let page, _):
            let params: Parameters = ["page":page]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
            urlRequest.allHTTPHeaderFields = authHeaders
            break
        case .createGistWith(let description, let isPublic, let files):
         
            var filesParams:Parameters = [:]
            for file in files {
                var contentParams: Parameters = [:]
                contentParams["content"] = file.content
                filesParams[file.name] = contentParams
            }
           
            let params: Parameters = ["description": description,"public":"\(isPublic)", "files": filesParams]

            urlRequest.allHTTPHeaderFields = authHeaders
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: params)
            break
        }
        return urlRequest
    }
    
    
    
    
    
}
