//
//  ErrorHandler.swift
//  TESTGists
//
//  Created by Serhii Ostrovetskyi on 8/22/19.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit

protocol ErrorHandler: class  {
    func handleError(_ error: Error, action: UIAlertAction)
}

extension ErrorHandler where Self: UIViewController {
    func handleError(_ error: Error, action: UIAlertAction) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
