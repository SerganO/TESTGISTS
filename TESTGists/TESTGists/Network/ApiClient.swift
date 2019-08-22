//
//  ApiClient.swift
//  TESTGists
//
//  Created by Serhii Ostrovetskyi on 8/21/19.
//  Copyright © 2019 dev. All rights reserved.
//

import Foundation
import Alamofire.Swift

class ApiClient {
    static let client = ApiClient()
    
    func loginWith(username: String, password: String,
                   success: @escaping (_ response: Any?) -> Void,
                   failure: @escaping (_ error: Error) -> Void) {
        let request = ApiRouter.login(username: username, password: password)
        sendRequest(request, success: success, failure: failure)
        
    }
    
    func getGistsForPage(_ page: Int, isPublic: Bool,
                   success: @escaping (_ response: Any?) -> Void,
                   failure: @escaping (_ error: Error) -> Void) {
        let request = ApiRouter.getGistsForPage(page: page, isPublic: isPublic)
        sendRequest(request, success: success, failure: failure)
        
    }
    
    func createGistWith(description: String, isPublic: Bool, files:[GistFile],
                         success: @escaping (_ response: Any?) -> Void,
                         failure: @escaping (_ error: Error) -> Void) {
        let request = ApiRouter.createGistWith(description: description, isPublic: isPublic, files: files)
        sendRequest(request, success: success, failure: failure)
        
    }
    
    
    func sendRequest(_ request: ApiRouter,
                     success: @escaping (_ response: Any?) -> Void,
                     failure: @escaping (_ error: Error) -> Void) {
        
        Alamofire.request(request).responseData { (response) in
            switch response.result {
                
            case .success(_):
                guard let data = response.data else {
                    failure(ApiClientError.unknownError)
                    return
                }
                switch request {
                    
                case .login:
                    let decoder = JSONDecoder()
                    let user = try? decoder.decode(User.self, from: data)
                    if let authorizeUser = user {
                        success(authorizeUser)
                    } else {
                        failure(ApiClientError.unknownError)
                    }
                case .getGistsForPage:
                    let decoder = JSONDecoder()
                    let _gists = try? decoder.decode([Gist].self, from: data)
                    print(response.request?.url ?? "NO URL")
                    if let gists = _gists {
                        success(gists)
                        print("SUCCESS")
                    } else {
                        failure(ApiClientError.unknownError)
                        print("FAIL")
                    }
                case .createGistWith:
                    success(data)
                    print("Gists")
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    
}
