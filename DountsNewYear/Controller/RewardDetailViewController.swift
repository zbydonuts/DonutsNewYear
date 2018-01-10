//
//  RewardDetailViewController.swift
//  DountsNewYear
//
//  Created by 朱　冰一 on 2017/12/20.
//  Copyright © 2017年 cookie. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import MBProgressHUD

class RewardDetailViewController: UIViewController {
    
    var data: Reward! {
        didSet{
            detailLabel.text = data.detail
            noStockView.isHidden = (data.count != 0)
            infoView.countLabel.text = "\(data.count)個"
            infoView.layoutIfNeeded()
            if let fav = UserManager.shared.user.favRewards, fav.contains(data.key) {
                favButton.setImage(UIImage(named: "detailHeartOn"), for: .normal)
            }else{
                favButton.setImage(UIImage(named: "detailHeartOff"), for: .normal)
            }
            imageView.kf.setImage(with: URL(string: data.imgUrl), options: [.cacheOriginalImage])
            infoView.keyLabel.text = data.key
        }
    }
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = true
        return view
    }()
    
    var separateLine: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(white: 0.8, alpha: 1.0).cgColor
        return layer
    }()
    
    lazy var favButton: UIButton = { [unowned self] in
        let button = UIButton()
        button.addTarget(self, action: #selector(favButtonDidTouch(sender:)), for: .touchUpInside)
        return button
    }()
    
    var detailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    /// key and in stock number
    lazy var infoView: RewardInfoView = { [unowned self] in
        let view = RewardInfoView()
        view.plusButton.addTarget(self, action: #selector(editStockDidTouch(sender:)), for: .touchUpInside)
        view.minusButton.addTarget(self, action: #selector(editStockDidTouch(sender:)), for: .touchUpInside)
        return view
    }()
    
    var noStockView: UIView = {
        let view = RewardNoStockView()
        view.isHidden = true
        return view
    }()
    
    var observerHandler: DatabaseHandle?
    var rewardRef: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        view.addSubview(infoView)
        view.addSubview(noStockView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(detailLabel)
        scrollView.layer.addSublayer(separateLine)
        imageView.addSubview(favButton)
        autolayout()
        setObserver(data.key)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = data.name
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard observerHandler != nil else { return }
        rewardRef?.removeObserver(withHandle: observerHandler!)
    }
    
    @objc func favButtonDidTouch(sender: Any) {
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
            favButton.setImage(UIImage(named: "detailHeartOn"), for: .normal)
        }else{
            favButton.setImage(UIImage(named: "detailHeartOff"), for: .normal)
        }
        let animation = CABasicAnimation()
        animation.keyPath = "transform"
        animation.toValue = CATransform3DMakeScale(1.1, 1.1, 1.0)
        animation.autoreverses = true
        animation.duration = 0.15
        favButton.layer.add(animation, forKey: "scale")
    }
    
    func autolayout() {
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.height.equalTo(Const.SCREEN_WIDTH)
            make.width.equalTo(Const.SCREEN_WIDTH)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.left.equalTo(5)
            make.width.equalTo(Const.SCREEN_WIDTH - 10)
            make.height.greaterThanOrEqualTo(0)
        }
        
        infoView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
            make.bottom.equalTo(0)
        }
        
        favButton.snp.makeConstraints { (make) in
            make.right.equalTo(-13)
            make.bottom.equalTo(-8)
            make.height.equalTo(31)
            make.width.equalTo(33)
        }
        
        noStockView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(infoView.snp.top)
        }
    }
    
    func setObserver(_ key: String) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        rewardRef = ref.child("Rewards").child(key)
        observerHandler = rewardRef?.observe(.value) { [weak self] (snapshot) in
            if let dict = snapshot.value as? NSDictionary, let key = self?.rewardRef?.key {
                guard let name = dict["name"] as? String,
                    let count = dict["count"] as? Int,
                    let imgUrl = dict["img_url"] as? String,
                    let detail = dict["detail"] as? String,
                    let category = dict["category"] as? String else { return }
                let re = Reward(key: key, count: count, name: name, imgUrl: imgUrl, detail: detail, category: category)
                self?.data = re
            }
        }
    }
    
    @objc func editStockDidTouch(sender: UIButton) {
        let title = sender == infoView.plusButton ? "在庫を一個追加しますか？" :  "在庫を一個減らしますか？"
        let diff = sender == infoView.plusButton ? 1 : -1
        let alert: UIAlertController = UIAlertController(title: title, message: nil, preferredStyle:  .alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            if diff < 0, self.data.count == 0 {
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.mode = .text
                hud.detailsLabel.text = "在庫ないので、更新を失敗しました"
                hud.hide(animated: true, afterDelay: 1.5)
                return
            }
            self.data.count += diff
            self.data.update()
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler:{
            (action: UIAlertAction!) -> Void in
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: Const.SCREEN_WIDTH,
                                        height: imageView.bounds.height + detailLabel.bounds.height + infoView.bounds.height + 5)
        separateLine.frame = CGRect(x: 0,
                                    y: imageView.frame.origin.y + imageView.bounds.height - 0.5,
                                    width: imageView.bounds.width, height: 0.5)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
