//
//  GistCell.swift
//  TESTGists
//
//  Created by Serhii Ostrovetskyi on 8/21/19.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit
import SnapKit

class GistCell: UITableViewCell {
    
    let ownerIcon = UIImageView()
    let ownerLabel = UILabel()
    let descriptionTextView = UITextView()
    
    let iconSize: CGFloat = 40
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constructor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        constructor()
    }
    
    func constructor() {
        let container = UIView()
        let ownerContainer = UIView()
        
        ownerIcon.layer.cornerRadius = iconSize / 2
        ownerIcon.layer.masksToBounds = true
        ownerContainer.addSubview(ownerIcon)
        ownerIcon.snp.makeConstraints { (make) in
            make.height.equalTo(iconSize)
            make.width.equalTo(iconSize)
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        ownerContainer.addSubview(ownerLabel)
        ownerLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(ownerIcon.snp.trailing).offset(15)
        }
        
        container.addSubview(ownerContainer)
        ownerContainer.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        descriptionTextView.isEditable = false
        container.addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints { (make) in
            make.top.equalTo(ownerContainer.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(5)
        }
        contentView.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
}
