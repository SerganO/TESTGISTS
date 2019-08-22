//
//  ControlCell.swift
//  TESTGists
//
//  Created by Serhii Ostrovetskyi on 8/21/19.
//  Copyright © 2019 dev. All rights reserved.
//

import UIKit
import SnapKit

class ControlCell: UITableViewCell {
    
    let olderButton = UIButton(type: .system)
    let newestButton = UIButton(type: .system)
    
    
    
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
        
        
        
        container.addSubview(newestButton)
        newestButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(30)
            make.height.equalTo(60)
            make.centerY.equalToSuperview()
        }
        
        container.addSubview(olderButton)
        olderButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-30)
            make.height.equalTo(60)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
}

