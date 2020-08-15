//
//  DetailInfoScreen.swift
//  BnetTestApp
//
//  Created by a.kurganova on 15.08.2020.
//  Copyright © 2020 a.kurganova. All rights reserved.
//

import Foundation
import UIKit

final class DetailInfoScreen: UIViewController {
    fileprivate let labelInfo = UITextView()
    fileprivate let objectInfo: EntitiesArrayObject
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLabel()
    }
    
    init(object: EntitiesArrayObject) {
        self.objectInfo = object
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLabel() {
        view.addSubview(labelInfo)
        labelInfo.translatesAutoresizingMaskIntoConstraints = false
        labelInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        labelInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        labelInfo.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        labelInfo.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                             constant: -20).isActive = true
        labelInfo.isEditable = false

        labelInfo.text = " body: \(objectInfo.body)"
    }
}
