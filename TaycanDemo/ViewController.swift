//
//  ViewController.swift
//  TaycanDemo
//
//  Created by Mengyu Li on 2018/12/27.
//  Copyright © 2018 Limengyu. All rights reserved.
//

import UIKit
import Taycan

class ViewController: UIViewController {

    private lazy var actionButton = { () -> UIButton in
        let actionButton = UIButton(type: .custom)
        actionButton.setTitle("Go", for: .normal)
        actionButton.setTitleColor(.black, for: .normal)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addTarget(self, action: #selector(goAction), for: .touchUpInside)
        return actionButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupUI()
    }

    private lazy var db = { () -> Database in
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = "taycan"
        let path = (url?.path ?? "") + "/" + fileName
        let db = Taycan.Database(path: path)
        return db
    }()
    private lazy var index = 0
}

extension ViewController {

    private func setupUI() {
        self.view.addSubview(self.actionButton)
        self.actionButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.actionButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.actionButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.actionButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }

    @objc
    private func goAction() {
        switch self.index % 2 {
        case 0:
            self.db.store(key: "123", value: "abcdsaofaojfajfijfi;jsadfj;akf'dODKodjioajfoijoifjsoijgosajfjiosejfpa;sdka;dk🙏🙏🙏🙏🙏🙏🙏🙏")
        case 1:
            let value: String? = self.db.fetchValue(key: "123")
            print(value)
        default:
            break
        }
        self.index += 1
    }
}

