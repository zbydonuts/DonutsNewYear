//
//  RewardCellObserverable.swift
//  DountsNewYear
//
//  Created by 朱　冰一 on 2017/12/23.
//  Copyright © 2017年 cookie. All rights reserved.
//

import Foundation
import Firebase

protocol RewardCellObservable : class {
    var data: Reward! { get set }
    var observerHandler: DatabaseHandle? { get set }
    var rewardRef: DatabaseReference? { get set }
    func setObserver(_ key: String)
    func removeObserver()
    func updateCell()
}

extension RewardCellObservable {
    func setObserver(_ key: String) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        rewardRef = ref.child("Rewards").child(key)
        observerHandler = rewardRef?.observe(.value) { [weak self] (snapshot) in
            guard let sSelf = self else { return }
            if let dict = snapshot.value as? NSDictionary {
                guard let name = dict["name"] as? String,
                    let count = dict["count"] as? Int,
                    let imgUrl = dict["img_url"] as? String,
                    let detail = dict["detail"] as? String,
                    let category = dict["category"] as? String else { return }
                sSelf.data.count = count
                sSelf.data.name = name
                sSelf.data.imgUrl = imgUrl
                sSelf.data.detail = detail
                sSelf.data.category = category
                sSelf.updateCell()
            }
        }
    }
    
    func removeObserver() {
        guard observerHandler != nil else { return }
        rewardRef?.removeObserver(withHandle: observerHandler!)
    }
}
