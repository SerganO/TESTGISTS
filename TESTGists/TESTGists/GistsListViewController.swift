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

class GistsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    var user = User()
    let tableView = UITableView()
    var currentPage = 1
    let footerView = UIView()
    var showedGists: [Gist] = []
    let refreshControl = UIRefreshControl()

    
    var loadMoreStatus = true
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
        getGistsForPage(page: currentPage, completion: {
            self.tableView.setContentOffset(.zero, animated: true)
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        })
        
        let createButton = UIButton(type: .system)
        createButton.setTitle("Create", for: .normal)
        createButton.addTarget(self, action: #selector(navigateToCreateGistVC), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: createButton)
        
    }
    
    @objc func loadOlder() {
        currentPage += 1
        getGistsForPage(page: currentPage, completion: {self.tableView.setContentOffset(.zero, animated: true)
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        })
    }
    
    @objc func loadNewest() {
        guard currentPage != 1 else {
            return
        }
        currentPage -= 1
        getGistsForPage(page: currentPage, completion: {self.tableView.setContentOffset(.zero, animated: true)
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        })
    }
    
    
    @objc func refresh() {
        currentPage = 1
        loadMoreStatus = true
        refreshing = true
        getGistsForPage(page: currentPage, completion: {self.tableView.setContentOffset(.zero, animated: true)
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        })
    }
    
    func setupTableView() {
        tableView.register(GistCell.self, forCellReuseIdentifier: gistsCellIdentifier)
        tableView.register(ControlCell.self, forCellReuseIdentifier: controlCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.addSubview(refreshControl)
        tableView.tableFooterView = footerView
    }
    

    
    func getGistsForPage(page: Int, completion: @escaping  () -> Void) {
        let activityData = ActivityData()
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        ApiClient.client.getGistsForPage(page, success: { (response) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            guard let gists = response as? [Gist] else {
                return
            }
            print("PAGE \(page)")
            self.showedGists = gists
            self.loadMoreStatus = false
            self.refreshing = false
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }) { (error) in
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            self.loadMoreStatus = false
            self.refreshing = false
            self.refreshControl.endRefreshing()
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
