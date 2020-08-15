//
//  AddNewEntryViewController.swift
//  BnetTestApp
//
//  Created by a.kurganova on 14.08.2020.
//  Copyright © 2020 a.kurganova. All rights reserved.
//

import Foundation
import UIKit

final class AddNewEntryViewController: UIViewController {
    private let entryInput = UITextView()
    fileprivate let viewButtons = UIView()
    fileprivate var bottom = NSLayoutConstraint()
    
    fileprivate var token: String
    fileprivate var session: String
    fileprivate var entriesProcessor: EntriesProcessorProtocol
    
    fileprivate var delegateSharingEntries: ShareEntriesDelegate?
    
    init(entriesProcessor: EntriesProcessorProtocol, token: String, session: String, delegate: ShareEntriesDelegate?) {
        self.entriesProcessor = entriesProcessor
        self.token = token
        self.session = session
        super.init(nibName: nil, bundle: nil)
        self.delegateSharingEntries = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let tapHideKey = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapHideKey)
        
        setupElements()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    fileprivate func setupElements() {
        [entryInput, viewButtons].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            $0.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        }
        
        entryInput.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        entryInput.heightAnchor.constraint(lessThanOrEqualToConstant: view.frame.height).isActive = true
        entryInput.layer.borderColor = UIColor.gray.cgColor
        entryInput.layer.borderWidth = 0.3
        
        viewButtons.topAnchor.constraint(equalTo: entryInput.bottomAnchor, constant: 10).isActive = true
        bottom = viewButtons.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        bottom.isActive = true
        
        let cancelChangesButton = UIButton(type: .system)
        let saveChangesButton = UIButton(type: .system)
        
        [cancelChangesButton, saveChangesButton].forEach {
            viewButtons.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: viewButtons.topAnchor, constant: 10).isActive = true
            $0.bottomAnchor.constraint(equalTo: viewButtons.bottomAnchor, constant: -10).isActive = true
            $0.layer.cornerRadius = 8
            $0.setTitleColor(.black, for: .normal)
        }

        cancelChangesButton.leadingAnchor.constraint(equalTo: viewButtons.leadingAnchor, constant: 10).isActive = true
        cancelChangesButton.trailingAnchor.constraint(equalTo: viewButtons.trailingAnchor,
                                                      constant: -view.frame.width/2).isActive = true
        cancelChangesButton.backgroundColor = UIColor(red: 0.878, green: 0.878, blue: 0.878, alpha: 1)
        cancelChangesButton.setTitle("Отменить", for: .normal)
        cancelChangesButton.addTarget(self, action: #selector(cancelChanges), for: .touchUpInside)
        
        saveChangesButton.leadingAnchor.constraint(equalTo: cancelChangesButton.trailingAnchor, constant: 20).isActive = true
        saveChangesButton.trailingAnchor.constraint(equalTo: viewButtons.trailingAnchor, constant: -10).isActive = true
        saveChangesButton.backgroundColor = UIColor(red: 0.802, green: 0.913, blue: 0.692, alpha: 1)
        saveChangesButton.setTitle("Сохранить", for: .normal)
        saveChangesButton.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
    }
    
    @objc
    private func cancelChanges() {
        entryInput.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func saveChanges() {
        entriesProcessor.addEntry(token: self.token, session: self.session, body: entryInput.text,
                                   completion: { [weak self] (entry, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                    switch error {
                    case .notFoundEntry:
                        showAlertError(error: .notFoundEntry, view: self!)
                    default:
                        showAlertError(error: .unknown, view: self!)
                    }
                    return
                }
               
                guard entry != nil else {
                    showAlertError(error: .notFoundEntry, view: self!)
                    return
                }
                self?.delegateSharingEntries?.updateEntriesAgain()
                self?.dismiss(animated: true, completion: nil)
            }
       })
    }
    
    @objc
    fileprivate func hideKeyboard() {
        entryInput.endEditing(true)
    }
}

extension AddNewEntryViewController {
    @objc
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottom.isActive = false
            bottom = viewButtons.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardSize.height)
            bottom.isActive = true
        }
    }

    @objc
    func keyboardWillHide(notification: NSNotification) {
        bottom.isActive = false
        bottom = viewButtons.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        bottom.isActive = true
    }
}
