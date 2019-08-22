//
//  GistsListViewController.swift
//  TESTGists
//
//  Created by Serhii Ostrovetskyi on 8/21/19.
//  Copyright © 2019 dev. All rights reserved.
//

import Foundation
import SnapKit
import Alamofire.Swift
import NVActivityIndicatorView

class GistsListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var user = User()
    let tableView = UITableView()
    var currentPage = 1
    let footerView = UIView()
    var showedGists: [Gist] = []
    let refreshControl = UIRefreshControl()
    var isPublic = true
    let typeSwitch = UISwitch()

    
    var typeChanging = false
    var refreshing = false
    
    let gistsCellIdentifier = "gistsCell"
    let controlCellIdentifier = "controlCell"
    
    @objc func navigateToCreateGistVC() {
        let createVC = CreateGistViewController()
        navigationController?.pushViewController(createVC, animated: true)
    }
    
    // MARK: - UIViewController
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        
        guard user.login != "" else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        setupTableView()
        getGistsForPage(page: currentPage)
        
        let createButton = UIButton(type: .system)
        createButton.setTitle("Create", for: .normal)
        createButton.addTarget(self, action: #selector(navigateToCreateGistVC), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: createButton)
        typeSwitch.addTarget(self, action: #selector(changeStyle), for: .valueChanged)
        navigationItem.rightBarButtonItems?.append(UIBarButtonItem(customView: typeSwitch))
        
    }
    
    @objc func loadOlder() {
        currentPage += 1
        getGistsForPage(page: currentPage)
    }
    
    @objc func loadNewest() {
        guard currentPage != 1 else {
            return
        }
        currentPage -= 1
        getGistsForPage(page: currentPage)
    }
    
    @objc func changeStyle() {
        guard !typeChanging else {
            return
        }
        typeChanging = true
        isPublic = !isPublic
        currentPage = 1
        getGistsForPage(page: currentPage)
    }
    
    
    @objc func refresh() {
        currentPage = 1
        refreshing = true
        getGistsForPage(page: currentPage)
    }
    
    func setupTableView() {
        tableView.register(GistCell.self, forCellReuseIdentifier: gistsCellIdentifier)
        tableView.register(ControlCell.self, forCellReuseIdentifier: controlCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.addSubview(refreshControl)
        tableView.tableFooterView = footerView
    }
    
    func getGistsForPage(page: Int) {
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        ApiClient.client.getGistsForPage(page, isPublic: self.isPublic, success: { (response) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            guard let gists = response as? [Gist] else {
                return
            }
            print("PAGE \(page)")
            print("RETURN EQUAL GIST \(self.showedGists == gists)")
            self.showedGists = gists
            self.refreshing = false
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            if self.tableView.numberOfRows(inSection: 0) > 0 {
            self.tableView.setContentOffset(.zero, animated: false)
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
            self.typeChanging = false

        }) { (error) in
            if self.typeChanging {
                self.typeSwitch.setOn(self.isPublic, animated: true)
                self.isPublic = !self.isPublic
                self.typeChanging = false
            }
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            self.refreshing = false
            self.refreshControl.endRefreshing()
            self.handleError(error)
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !refreshing else {
            print("CANCELED")
            return 0
        }
        if showedGists.count == 0 {
            return 0
        }
        return showedGists.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: controlCellIdentifier, for: indexPath) as! ControlCell
            cell.newestButton.addTarget(self, action: #selector(loadNewest), for: .touchUpInside)
            cell.olderButton.addTarget(self, action: #selector(loadOlder), for: .touchUpInside)
            cell.newestButton.setTitle("NEWEST", for: .normal)
            cell.olderButton.setTitle("OLDER", for: .normal)
            cell.newestButton.isEnabled = currentPage > 1
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: gistsCellIdentifier, for: indexPath) as! GistCell
        let gist = showedGists[indexPath.row]
        cell.descriptionTextView.text = gist.description
        cell.ownerLabel.text = gist.owner.login
        cell.ownerIcon.image = #imageLiteral(resourceName: "account_ava_placeholder")
        cell.ownerIcon.loadImage(url: URL(string: gist.owner.avatarUrl))
        return cell
    }
    
}


