//
//  RewardFavTableViewCell.swift
//  DountsNewYear
//
//  Created by 朱　冰一 on 2017/12/23.
//  Copyright © 2017年 cookie. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Kingfisher

class RewardFavCollectionViewCell: UICollectionViewCell, RewardCellObservable {
    
    var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    var countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    var labelBgLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(white: 0.0, alpha: 0.6).cgColor
        layer.speed = 100
        return layer
    }()
    
    var noStockView: RewardNoStockView = {
        let view = RewardNoStockView()
        view.label.font = UIFont.boldSystemFont(ofSize: 18)
        view.isHidden = true
        return view
    }()
    
    /// RewardCellObservable
    var data: Reward! {
        didSet{
           updateCell()
        }
    }
    
    var observerHandler: DatabaseHandle?
    var rewardRef: DatabaseReference?
    
    let p = ResizingImageProcessor(referenceSize: CGSize(width: 250, height: 250), mode: .aspectFit)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(imageView)
        layer.addSublayer(labelBgLayer)
        addSubview(countLabel)
        addSubview(noStockView)
        autolayout()
    }
    
    func autolayout() {
        imageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        noStockView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-5)
        }
    }
    
    func updateCell() {
        imageView.kf.setImage(with: URL(string: data.imgUrl), options: [.processor(p), .cacheOriginalImage])
        if data.count > 0 {
            noStockView.isHidden = true
            countLabel.isHidden = false
            labelBgLayer.isHidden = false
            countLabel.text = "残り\(data.count)個"
        }else{
            noStockView.isHidden = false
            countLabel.isHidden = true
            labelBgLayer.isHidden = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        labelBgLayer.frame = CGRect(x: 0, y: bounds.height - 30, width: bounds.width, height: 30)
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
