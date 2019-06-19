//
//  ViewController.swift
//  TaycanDemo
//
//  Created by Mengyu Li on 2019/6/11.
//  Copyright © 2019 L1MeN9Yu. All rights reserved.
//

import UIKit
import Taycan

class ViewController: UIViewController {

    private lazy var environment = { () -> Environment? in
//        guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.absoluteString else { return nil }
        guard let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return nil }
        do {
            let path = documentPath + "/lmdb.taycan"
            if (!FileManager.default.fileExists(atPath: path)) { try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true) }
            return try Environment(path: path)
        } catch let error {
            return nil
        }
    }()

    private lazy var db = { () -> Database? in
        do {
            let db = try self.environment?.openDatabase(named: "default", flags: [.create])
            return db
        } catch let error {
            return nil
        }
    }()

    private lazy var putActionButton = { () -> UIButton in
        let putActionButton = UIButton(type: .custom)
        putActionButton.setTitle("PUT", for: .normal)
        putActionButton.setTitleColor(.black, for: .normal)
        putActionButton.addTarget(self, action: #selector(putButtonAction), for: .touchUpInside)
        putActionButton.translatesAutoresizingMaskIntoConstraints = false
        return putActionButton
    }()

    private lazy var getActionButton = { () -> UIButton in
        let getActionButton = UIButton(type: .custom)
        getActionButton.setTitle("GET", for: .normal)
        getActionButton.setTitleColor(.black, for: .normal)
        getActionButton.addTarget(self, action: #selector(getButtonAction), for: .touchUpInside)
        getActionButton.translatesAutoresizingMaskIntoConstraints = false
        return getActionButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
    }
}

extension ViewController {
    @objc
    private func putButtonAction(button: UIButton) {
        try? self.db?.put(value: "777", forKey: "555")
    }

    @objc
    private func getButtonAction(button: UIButton) {
        let result = (try? self.db?.get(type: String.self, forKey: "555")) ?? "value is nil"
        print(result)
    }
}

// MARK: - Setup
extension ViewController {
    private func setupUI() {
        self.view.addSubview(self.getActionButton)
        self.view.addSubview(self.putActionButton)

        self.getActionButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.getActionButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.getActionButton.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true
        self.getActionButton.heightAnchor.constraint(equalToConstant: 45).isActive = true

        self.putActionButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.putActionButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.putActionButton.bottomAnchor.constraint(equalTo: self.getActionButton.topAnchor).isActive = true
        self.putActionButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
}
