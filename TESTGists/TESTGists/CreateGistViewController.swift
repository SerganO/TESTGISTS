//
//  CreateGistViewController.swift
//  TESTGists
//
//  Created by Serhii Ostrovetskyi on 8/22/19.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit
import SnapKit
import NVActivityIndicatorView

class CreateGistViewController: UIViewController {

    let descriptionTextView = UITextView()
    let fileContentTextView = UITextView()
    let publicSwith = UISwitch()
    let descriptionLabel = UILabel()
    let fileContentLabel = UILabel()
    let publicLabel = UILabel()
    let createButton = UIButton(type: .system)
    
    
    
    @objc func createButtonTap() {
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        ApiClient.client.createGistWith(description: descriptionTextView.text, isPublic: publicSwith.isOn, files: [GistFile(name: "filename.txt:", content: fileContentTextView.text)], success: { (response) in
            print("SUCCESS)))")
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            print("FAIL((((")
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        publicLabel.text = "Public"
        descriptionLabel.text = "Description"
        fileContentLabel.text = "Content"
        descriptionTextView.text = ""
        fileContentTextView.text = ""
        createButton.setTitle("Create", for: .normal)
        createButton.addTarget(self, action: #selector(createButtonTap), for: .touchUpInside)
        
        view.addSubview(publicLabel)
        publicLabel.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            } else {
                make.top.equalTo(topLayoutGuide.snp.bottom).offset(15)
            }
            
            make.leading.equalToSuperview().offset(15)
        }
        view.addSubview(publicSwith)
        publicSwith.snp.makeConstraints { (make) in
            make.top.equalTo(publicLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
        }
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(publicSwith.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
        }
        view.addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(80)
        }
        view.addSubview(fileContentLabel)
        fileContentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
        }
        view.addSubview(fileContentTextView)
        fileContentTextView.snp.makeConstraints { (make) in
            make.top.equalTo(fileContentLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: createButton)
    }
    
}
