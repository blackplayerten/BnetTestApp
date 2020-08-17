//
//  ErrorsProcessor.swift
//  BnetTestApp
//
//  Created by a.kurganova on 14.08.2020.
//  Copyright © 2020 a.kurganova. All rights reserved.
//

import Foundation
import UIKit

enum NativeErrors: String {
    case noConnection = "нет интернет-соединения"
    case unknown = "неизвестная ошибка сервера"
}

func showAlertError(error: NativeErrors, view: UIViewController, updateData: @escaping ()->Void) {
    let alert = UIAlertController(title: "Произошла ошибка",
                                  message: error.rawValue,
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Обновить данные", style: .default, handler: {_ in
        alert.dismiss(animated: true, completion: nil)
        updateData()
    }))
    view.present(alert, animated: true, completion: nil)
}
