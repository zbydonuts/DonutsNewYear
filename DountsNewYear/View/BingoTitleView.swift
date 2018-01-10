//
//  BingoTitleView.swift
//  DountsNewYear
//
//  Created by cookie on 26/12/2017.
//  Copyright © 2017 cookie. All rights reserved.
//

import Foundation
import UIKit

class BingoTitleView: UIView {
    
    var label = [UILabel]()
    var textList = ["B", "I", "N", "G", "O"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
