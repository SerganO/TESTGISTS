//
//  UIImageView+GetImageFromURL.swift
//  TESTGists
//
//  Created by Serhii Ostrovetskyi on 8/21/19.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit
import Alamofire

extension UIImageView {
    
    
    func loadImage(url: URL?) {
        guard let url = url else { return }
        if let imageFromCache = CacheManager.imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        Alamofire.request(url).responseData { (response) in
            guard let data = response.result.value else {
                return
            }
            if let image = UIImage(data: data) {
                CacheManager.imageCache.setObject(image, forKey: url as AnyObject)
                self.image = image
            }
        }
    }
    
    
    
    
}
