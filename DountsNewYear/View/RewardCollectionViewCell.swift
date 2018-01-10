//
//  RewardCollectionViewCell.swift
//  DountsNewYear
//
//  Created by cookie on 19/12/2017.
//  Copyright © 2017 cookie. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import Firebase

class RewardCollectionViewCell: UICollectionViewCell, RewardCellObservable {
    
    var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    var countTag: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Tag")
        view.contentMode = .scaleAspectFit
        view.tintColor = UIColor(white: 0.3, alpha: 1.0)
        return view
    }()
    var countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    
    var separateLine: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(white: 0.88, alpha: 1.0).cgColor
        return layer
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    var favButton: UIButton = {
        let button = UIButton()
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        return button
    }()
    
    var noStockView: UIView = {
        let view = RewardNoStockView()
        view.isHidden = true
        return view
    }()

    let p = ResizingImageProcessor(referenceSize: CGSize(width: 300, height: 300), mode: .aspectFit)
    
    
    /// RewardCellObservable
    var data: Reward! {
        didSet{
           updateCell()
        }
    }
    var observerHandler: DatabaseHandle?
    var rewardRef: DatabaseReference?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.layer.addSublayer(separateLine)
        contentView.addSubview(nameLabel)
        contentView.addSubview(countTag)
        countTag.addSubview(countLabel)
        contentView.addSubview(favButton)
        contentView.addSubview(noStockView)
        backgroundColor = .white
        autolayout()
        favButton.addTarget(self, action: #selector(favButtonClicked(sender:)), for: .touchUpInside)
    }
    
    func autolayout(){
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(imageView.snp.width)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-5)
            make.left.equalTo(5)
            make.right.equalTo(favButton.snp.left).offset(-2)
        }
        
        countTag.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.width.equalTo(20)
            make.height.equalTo(29)
            make.left.equalTo(3)
        }
        
        countLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(0)
        }
        
        favButton.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.width.equalTo(30)
            make.height.equalTo(28)
        }
        
        noStockView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func updateCell() {
        nameLabel.text = data.name
        countLabel.text = "\(data.count)"
        noStockView.isHidden = (data.count != 0)
        //isUserInteractionEnabled = (data.count != 0)
        imageView.kf.setImage(with: URL(string: data.imgUrl), options: [.processor(p), .cacheOriginalImage])
        if let fav = UserManager.shared.user.favRewards, fav.contains(data.key) {
            favButton.setImage(UIImage(named: "FavOn"), for: .normal)
        }else{
            favButton.setImage(UIImage(named: "FavOff"), for: .normal)
        }
    }
    
    @objc func favButtonClicked(sender: Any) {
        if var fav = UserManager.shared.user.favRewards {
            if fav.contains(data.key) {
                fav = fav.filter{ $0 != data.key }
            }else{
                fav.append(data.key)
            }
            UserManager.shared.user.favRewards = fav
        }else{
            let fav = [data.key]
            UserManager.shared.user.favRewards = fav
        }
        UserManager.shared.user.update()
        
        if let fav = UserManager.shared.user.favRewards, fav.contains(data.key) {
            favButton.setImage(UIImage(named: "FavOn"), for: .normal)
        }else{
            favButton.setImage(UIImage(named: "FavOff"), for: .normal)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        separateLine.frame = CGRect(x: 0,
                                    y: bounds.height - 30,
                                    width: bounds.width, height: 0.5)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
