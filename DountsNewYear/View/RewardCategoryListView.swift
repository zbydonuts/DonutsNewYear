//
//  RewardCategoryView.swift
//  DountsNewYear
//
//  Created by 朱　冰一 on 2017/12/21.
//  Copyright © 2017年 cookie. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol RewardCategoryListViewDelegate : class {
    func categorySelected(_ category: String)
}

class RewardCategoryListView: UIView {
    lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.separatorColor = UIColor(white: 0.85, alpha: 1.0)
        tableView.register(RewareCategoryCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    var selecetRow: Int? = nil
    
    var data: [String] = [] {
        didSet{
            tableView.reloadData()
        }
    }

    weak var delegate: RewardCategoryListViewDelegate?
    
    //MARK: Function
    init() {
        super.init(frame: .zero)
        layer.cornerRadius = 5
        clipsToBounds = true
        layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        layer.borderWidth = 1.0
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
   
    func loadData() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let categoryRef = ref.child("RewardCategory")
        categoryRef.observeSingleEvent(of: .value) { (snapshot) in
            var result = [String]()
            for child in snapshot.children {
                let category = child as! DataSnapshot
                if let categoryStr = category.value as? String {
                    result.append(categoryStr)
                }
            }
            self.data = result
        }
    }

    func show(_ show: Bool) {
        let x:CGFloat = show ? 10 : -80
        guard x != frame.origin.x else { return }
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
            self.frame = CGRect(x: x, y: self.frame.origin.y, width: 80, height: 8 * 32)
        }) { (_) in
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension RewardCategoryListView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RewareCategoryCell {
            cell.titleLabel.text = data[indexPath.row]
            if selecetRow != nil, selecetRow == indexPath.row {
                cell.isSelected = true
            }else{
                cell.isSelected = false
            }
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.categorySelected(data[indexPath.row])
        selecetRow = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

class RewareCategoryCell: UITableViewCell {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override var isSelected: Bool {
        didSet{
            titleLabel.textColor = isSelected ? UIColor.white : UIColor.darkGray
            backgroundColor = isSelected ? UIColor.darkGray : UIColor.white
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        separatorInset = UIEdgeInsets.zero
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
