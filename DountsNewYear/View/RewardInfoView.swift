//
//  RewardInfoView.swift
//  DountsNewYear
//
//  Created by 朱　冰一 on 2017/12/23.
//  Copyright © 2017年 cookie. All rights reserved.
//

import Foundation
import UIKit

class RewardInfoView: UIView {
    var keyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    var restLabel: UILabel = {
        let label = UILabel()
        label.text = "残り"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    
    var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "stockAdd"), for: .normal)
        return button
    }()
    
    var minusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "stockDecrease"), for: .normal)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor(white: 0.0, alpha: 0.7)
        addSubview(keyLabel)
        addSubview(restLabel)
        addSubview(countLabel)
        addSubview(plusButton)
        addSubview(minusButton)
        autolayout()
    }
    
    func autolayout(){
        keyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        
        restLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(countLabel.snp.bottom).offset(-2)
            make.right.equalTo(countLabel.snp.left).offset(-5)
        }
        
        plusButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(31)
            make.centerX.equalToSuperview().offset(-40)
        }
        
        minusButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(31)
            make.centerX.equalToSuperview().offset(40)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

