//
//  ErrorsProcessor.swift
//  BnetTestApp
//
//  Created by a.kurganova on 14.08.2020.
//  Copyright © 2020 a.kurganova. All rights reserved.
//

import Foundation
import UIKit

func showAlertError(error: NetworkErrors, view: UIViewController) {
    let alert = UIAlertController(title: "Соединение с интернетом",
                                  message: """
                                    В данный момент интернет-соединение недоступно,
                                    ошибка : \(error)
                                  """, preferredStyle: .alert)
    alert.addAction(.init(title: "Закрыть", style: .cancel))
    view.present(alert, animated: true, completion: nil)
}
