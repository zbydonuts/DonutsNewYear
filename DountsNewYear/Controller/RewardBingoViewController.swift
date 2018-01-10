//
//  BingoViewController.swift
//  DountsNewYear
//
//  Created by cookie on 25/12/2017.
//  Copyright © 2017 cookie. All rights reserved.
//

import Foundation
import UIKit

class RewardBingoViewController: UIViewController {
    
    var bingoView: RewardBingoView = {
        let view = RewardBingoView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBar()
        view.addSubview(bingoView)
        view.backgroundColor = UIColor.groupTableViewBackground
        autolayout()
        bingoView.setObserver()
    }
    
    func setupNaviBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = UIColor.darkGray
        navigationItem.title = "ビンゴ"
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: .regular)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func autolayout() {
        bingoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
