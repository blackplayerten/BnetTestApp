//
//  ViewController.swift
//  BnetTestApp
//
//  Created by a.kurganova on 13.08.2020.
//  Copyright © 2020 a.kurganova. All rights reserved.
//

import UIKit
import PromiseKit

class MainViewController: UIViewController {
    lazy fileprivate var tableForJson: UITableView = {
        return UITableView(frame: view.frame)
    }()

    fileprivate var sessionProcessor: SessionProcessorProtocol
    fileprivate var entriesProcessor: EntriesProcessorProtocol
    fileprivate var token: String = ""
    fileprivate var session: String = ""
    
    fileprivate var entries = [EntitiesArrayObject]()

    init(sessionProcessor: SessionProcessorProtocol, entriesProcessor: EntriesProcessorProtocol) {
        self.sessionProcessor = sessionProcessor
        self.entriesProcessor = entriesProcessor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupNavigation()
        checkAuth()
    }
    
    fileprivate func setupNavigation() {
        navigationController?.navigationBar.topItem?.title = "BnetTest"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                            action: #selector(addEntry))
    }
    
    @objc
    private func addEntry() {
        let addEntryViewController = AddNewEntryViewController(entriesProcessor: self.entriesProcessor,
                                                               token: self.token, session: self.session,
                                                               delegate: self)
        present(addEntryViewController, animated: true, completion: nil)
    }
    
    fileprivate func setupTable() {
        view.addSubview(tableForJson)
        tableForJson.delegate = self
        tableForJson.dataSource = self
        tableForJson.register(Cell.self, forCellReuseIdentifier: "cell")
        tableForJson.estimatedRowHeight = 2

        tableForJson.translatesAutoresizingMaskIntoConstraints = false
        tableForJson.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        tableForJson.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        tableForJson.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableForJson.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                             constant: -20).isActive = true
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? Cell else {
            return UITableViewCell()
        }
        cell.contentView.subviews.forEach {
            $0.removeFromSuperview()
        }
        cell.fillCell(data: entries[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailInfo = DetailInfoScreen(object: entries[indexPath.row])
        navigationController?.pushViewController(detailInfo, animated: true)
    }
}

extension MainViewController: UITableViewDelegate {
    
}

// MARK: ---- session ------
extension MainViewController {
    fileprivate func checkAuth() {
        firstly {
            self.sessionProcessor.getToken()
        }.then { (token: String) -> Promise<String> in
            self.token = token
            return self.sessionProcessor.getSession(token: token)
        }.done { (session: String) in
            self.session = session
            self.setupTable()
            self.showEntries()
        }.catch { (error) in
            print(error)
            switch error as? NetworkErrors {
            case .noConnection:
                showAlertError(error: .noConnection, view: self, updateData: self.checkAuth)
            default:
                showAlertError(error: .unknown, view: self, updateData: self.checkAuth)
            }
        }
    }
}

protocol ShareEntriesDelegate: class {
    func updateEntriesAgain()
}

// MARK: ---- entries ------
extension MainViewController: ShareEntriesDelegate {
    fileprivate func showEntries() {
        entriesProcessor.getEntries(token: self.token, session: self.session,
                                     completion: { [weak self] (entry, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                    switch error {
                    case .noConnection:
                        showAlertError(error: .noConnection, view: self!, updateData: self!.checkAuth)
                    default:
                        showAlertError(error: .unknown, view: self!, updateData: self!.checkAuth)
                    }
                    return
                }
                
                guard let entry = entry else {
                    showAlertError(error: .unknown, view: self!, updateData: self!.checkAuth)
                    return
                }
                
                guard let entriesData = entry.data.first else {
                    return
                }
                self?.entries = entriesData
                self?.tableForJson.reloadData()
            }
        })
    }

    func updateEntriesAgain() {
        showEntries()
    }
}
