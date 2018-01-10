//
//  RewardNoStockView.swift
//  DountsNewYear
//
//  Created by 朱　冰一 on 2017/12/25.
//  Copyright © 2017年 cookie. All rights reserved.
//

import Foundation
import UIKit

class RewardNoStockView: UIView {
    var label: UILabel = {
        let label = UILabel()
        label.text = "在庫なし"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    init(){
        super.init(frame: .zero)
        addSubview(label)
        backgroundColor = UIColor(white: 0.0, alpha: 0.8)
        label.sizeToFit()
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
