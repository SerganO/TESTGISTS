//
//  StringConvertBase64.swift
//  TESTGists
//
//  Created by Serhii Ostrovetskyi on 8/22/19.
//  Copyright © 2019 dev. All rights reserved.
//

import Foundation

extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
