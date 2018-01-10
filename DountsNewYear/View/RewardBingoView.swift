//
//  AllBingoView.swift
//  DountsNewYear
//
//  Created by cookie on 25/12/2017.
//  Copyright © 2017 cookie. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class RewardBingoView: UIView {
    lazy var collectionView: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        let width: CGFloat = Const.SCREEN_WIDTH >= 375 ? (Const.SCREEN_WIDTH - 11) / 10 :  (Const.SCREEN_WIDTH - 9) / 8
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.contentInset = UIEdgeInsetsMake(1, 1, 1, 1)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = UIColor.groupTableViewBackground
        view.register(RewardBingoCell.self, forCellWithReuseIdentifier: "cell")
        return view
    }()
    
    var data = [Bingo]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    init() {
        super.init(frame: .zero)
        addSubview(collectionView)
        autolayout()
    }
    
    func setObserver() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let bingoRef = ref.child("Bingo")
        bingoRef.observe(.value) { [weak self](snapshot) in
            var result = [Bingo]()
            for child in snapshot.children {
                let bingo = child as! DataSnapshot
                let value = bingo.value as! Bool
                let key = bingo.key
                result.append(Bingo(key: key, value: value))
            }
            self?.data = result
        }
    }
    
    func autolayout() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RewardBingoView: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? RewardBingoCell {
            cell.label.text = "\(data[indexPath.item].key)"
            if data[indexPath.item].value {
                cell.setOn()
            }
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let bingoRef = ref.child("Bingo").child("\(indexPath.item + 1)")
        bingoRef.observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? Bool {
                bingoRef.setValue(!value)
                if let cell = collectionView.cellForItem(at: indexPath) as? RewardBingoCell {
                    cell.setStyle(!value)
                }
            }
        }
    }
}
