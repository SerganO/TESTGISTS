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
    private let decoder = JSONDecoder()
    private let manager = Alamofire.SessionManager.default
    
    init() {
        manager.session.configuration.timeoutIntervalForRequest = 60
    }
    
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
        
        manager.request(request).validate(statusCode: 200...300).responseData { (response) in
            print("================")
            print("Reponse request url: ")
            print(response.request?.url ?? "n/a")
            switch response.result {
                
            case .success(_):
                print("- Getting data -")
                guard let data = response.data else {
                    failure(ApiClientError.unknownError)
                    print("v Fail v")
                    print("=-=-=-=-=-=-=-=-")
                    return
                }
                print("^ Success ^")
                switch request {
                    
                case .login:
                    print("- login -")
                    do {
                        let user = try self.decoder.decode(User.self, from: data)
                        success(user)
                        print("^ Success ^")
                        print("=+=+=+=+=+=+=+=+")
                    } catch {
                        failure(ApiClientError.unknownError)
                        print("v Fail v")
                        print("=-=-=-=-=-=-=-=-")
                    }
                case .getGistsForPage:
                    print("- getGists -")
                    do {
                        let gists = try self.decoder.decode([Gist].self, from: data)
                        success(gists)
                        print("^ Success ^")
                        print("=+=+=+=+=+=+=+=+")
                    } catch {
                        failure(ApiClientError.unknownError)
                        print("v Fail v")
                        print("=-=-=-=-=-=-=-=-")
                    }
                case .createGistWith:
                    print("- createGist -")
                    success(data)
                    print("^ Success ^")
                    print("=+=+=+=+=+=+=+=+")
                }
                
            case .failure(let error):
                failure(error)
                print("v Fail v")
                print("=-=-=-=-=-=-=-=-")
            }
        }
    }
    
}
