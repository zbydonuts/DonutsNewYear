//
//  Model.swift
//  DountsNewYear
//
//  Created by cookie on 19/12/2017.
//  Copyright © 2017 cookie. All rights reserved.
//

import Foundation
import Firebase
import MBProgressHUD

class Bingo {
    var key: String
    var value: Bool
    init(key: String, value: Bool) {
        self.key = key
        self.value = value
    }
}

class User {
    var key: String
    var favRewards: [String]?
    
    init(key: String) {
        self.key = key
    }
    
    func update() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        if favRewards?.count == 0 {
            favRewards = ["ph"]
        }
        ref.child("Users").child(key).setValue(["fav_rewards": favRewards])
    }
}

class UserManager {
    static let shared = UserManager()
    var user: User!
    
    func checkLocalUser() {
        let ud = UserDefaults.standard
        if let key = ud.value(forKey: "userKey") as? String {
            var ref: DatabaseReference!
            ref = Database.database().reference()
            user = User(key: key)
            ref.child("Users").child(key).observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
                let value = snapshot.value as? NSDictionary
                let favRewards = value?["fav_rewards"] as? [String]
                self?.user.favRewards = favRewards
            })
        }else{
            var ref: DatabaseReference!
            ref = Database.database().reference()
            let child = ref.child("Users").childByAutoId()
            user = User(key: child.key)
            user.update()
            ud.set(child.key, forKey: "userKey")
        }
    }
}

class RewardManager {
    static let shared = RewardManager()
    var allData = [Reward]()
    func loadData(at view: UIView, complete: @escaping (_ data: [Reward]) -> Void) {
        allData.removeAll()
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let rewardRef = ref.child("Rewards")
        rewardRef.observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard let sSelf = self else { return }
            for child in snapshot.children {
                let reward = child as! DataSnapshot
                let dict = reward.value as! NSDictionary
                let key = reward.key
                guard let name = dict["name"] as? String,
                    let count = dict["count"] as? Int,
                    let imgUrl = dict["img_url"] as? String,
                    let detail = dict["detail"] as? String,
                    let category = dict["category"] as? String else { return }
                let re = Reward(key: key, count: count, name: name, imgUrl: imgUrl, detail: detail, category: category)
                sSelf.allData.append(re)
            }
            complete(sSelf.allData)
        }
    }
}

class Reward {
    var key: String
    var count: Int
    var name: String
    var detail: String
    var imgUrl: String
    var category: String
    
    init(key: String, count: Int, name: String, imgUrl: String, detail: String, category: String) {
        self.key = key
        self.count = count
        self.name = name
        self.imgUrl = imgUrl
        self.detail = detail
        self.category = category
    }
    
    func update() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("Rewards").child(key).setValue(["name": name, "count": count, "img_url": imgUrl, "detail": detail, "category": category])
    }
}

