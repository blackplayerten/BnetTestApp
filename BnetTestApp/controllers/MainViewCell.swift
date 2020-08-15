//
//  MainViewCell.swift
//  BnetTestApp
//
//  Created by a.kurganova on 13.08.2020.
//  Copyright © 2020 a.kurganova. All rights reserved.
//

import Foundation
import UIKit

final class Cell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillCell(data: EntitiesArrayObject) {
        let labelDaDm = UILabel()
        let labelBody = UILabel()
        [labelDaDm, labelBody].forEach {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
            $0.numberOfLines = 0
            $0.font = UIFont.systemFont(ofSize: 10)
        }
        
        labelDaDm.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        labelDaDm.heightAnchor.constraint(equalToConstant: 30).isActive = true
        labelDaDm.layer.borderColor = UIColor.black.cgColor
        labelDaDm.text = "da: " + data.da + "\ndm: " + data.dm
        
        labelBody.topAnchor.constraint(equalTo: labelDaDm.bottomAnchor).isActive = true
        labelBody.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        labelBody.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        let str: String = "Body: " + data.body
        labelBody.text = String(str[..<str.index(str.startIndex, offsetBy: min(str.count, 200))])
    }
}
