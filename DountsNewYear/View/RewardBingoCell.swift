//
//  BingoCell.swift
//  DountsNewYear
//
//  Created by cookie on 26/12/2017.
//  Copyright © 2017 cookie. All rights reserved.
//

import Foundation
import UIKit

class RewardBingoCell: UICollectionViewCell {
    var label: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    func setOn() {
        label.textColor = .white
        backgroundColor = .darkGray
    }
    
    func setStyle(_ value: Bool) {
        label.textColor = value ? .white : .darkGray
        backgroundColor = value ? .darkGray : .white
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.textColor = .darkGray
        backgroundColor = .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
