//
//  AuthorizationViewController.swift
//  TESTGists
//
//  Created by Serhii Ostrovetskyi on 8/21/19.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit
import SnapKit
import IQKeyboardManagerSwift
import NVActivityIndicatorView

class AuthorizationViewController: UIViewController, ErrorHandler {

    
    let usernameTextField = UITextField()
    let passwordTextField = UITextField()
    let okButton = UIButton(type: .system)
    
    
    // MARK: - UIViewController
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        usernameTextField.placeholder = "Username"
        usernameTextField.borderStyle = .line
        view.addSubview(usernameTextField)
        usernameTextField.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .line
        passwordTextField.isSecureTextEntry = true
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(usernameTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        okButton.setTitle("OK", for: .normal)
        okButton.addTarget(self, action: #selector(okButtonTap), for: .touchUpInside)
        view.addSubview(okButton)
        okButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 70
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func okButtonTap() {
        view.endEditing(true)
        guard let username = usernameTextField.text else {
            return
        }
        guard let password = passwordTextField.text else {
            return
        }
        
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        
        ApiClient.client.loginWith(username: username, password: password, success: { (response) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            guard let user = response as? User else {
                self.view.backgroundColor = .red
                print("parse error")
                return
            }
            print("congratulations")
            let gistsVC = GistsListViewController()
            gistsVC.user = user
            
            self.navigationController?.pushViewController(gistsVC, animated: true)
        }, failure: { (error) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            self.handleError(error, action: action)
        })
        
    }
    
    
    
}
