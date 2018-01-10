//
//  SecondViewController.swift
//  DountsNewYear
//
//  Created by cookie on 18/12/2017.
//  Copyright © 2017 cookie. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

class RewardFavViewController: UIViewController {
    
    lazy var collectionView: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        let cellWidth: CGFloat = UIScreen.main.bounds.width < 375 ? (Const.SCREEN_WIDTH - 8) / 3 : (Const.SCREEN_WIDTH - 10) / 4
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(RewardFavCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = UIColor.groupTableViewBackground
        view.contentInset = UIEdgeInsetsMake(2, 2, 0, 2)
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    
    var data: [Reward] = [] {
        didSet {
            collectionView.reloadData()
            MBProgressHUD.hide(for: view, animated: true)
        }
    }

    // MARK: Function
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBar()
        view.addSubview(collectionView)
        autolayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func autolayout() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    func setupNaviBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = UIColor.darkGray
        navigationItem.title = "お気に入り"
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: .regular)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func loadData() {
        data = RewardManager.shared.allData.filter{ (reward) -> Bool in
            if let fav = UserManager.shared.user.favRewards, fav.contains(reward.key) {
                return true
            }else{
                return false
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension RewardFavViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? RewardFavCollectionViewCell {
            cell.removeObserver()
            cell.data = data[indexPath.item]
            cell.setObserver(data[indexPath.item].key)
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //guard data[indexPath.item].count > 0 else { return }
        let vc = RewardDetailViewController()
        vc.data = data[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
}


