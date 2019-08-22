//
//  BaseViewController.swift
//  TESTGists
//
//  Created by Serhii Ostrovetskyi on 8/22/19.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, ErrorHandler {
    func handleError(_ error: Error) {
        showAlertWith(title: "Error", message: error.localizedDescription, actions: [])
    }
    

    func showAlertWith(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if actions.count > 0 {
            for action in actions {
                alert.addAction(action)
            }
        } else {
            let baseAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(baseAction)
        }
        present(alert, animated: true)
    }

}
