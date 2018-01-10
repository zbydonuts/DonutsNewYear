//
//  FirstViewController.swift
//  DountsNewYear
//
//  Created by cookie on 18/12/2017.
//  Copyright © 2017 cookie. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Kingfisher
import MBProgressHUD

class RewardListViewController: UIViewController {
    
    lazy var collectionView: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        let cellWidth = (Const.SCREEN_WIDTH - 6) / 2
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth + 30)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(RewardCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = UIColor.groupTableViewBackground
        view.contentInset = UIEdgeInsetsMake(2, 2, 0, 2)
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    
    lazy var searchBar: UISearchBar = { [unowned self] in
        let bar = UISearchBar()
        bar.isHidden = true
        bar.scopeBarBackgroundImage = UIImage()
        bar.delegate = self
        if #available(iOS 11.0, *) {
            bar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
        return bar
    }()
    
    var logoView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "DonutsIcon"))
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 115, height:44)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var searchButton: UIButton = {
        let searchButton = UIButton(type: .custom)
        searchButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        searchButton.setImage(UIImage(named: "Search"), for: .normal)
        searchButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        return searchButton
    }()
    
    lazy var showAllButton: UIButton = { [unowned self] in
        let button = UIButton()
        button.setTitle("すべての景品を表示する", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(white: 0.0, alpha: 0.7)
        button.isHidden = true
        button.addTarget(self, action: #selector(showAllButtonDidTouch(sender:)), for: .touchUpInside)
        return button
    }()
    
    var filterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "CategoryListIcon"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.imageEdgeInsets = UIEdgeInsetsMake(15, 20, 15, 7)
        return button
    }()
    
    lazy var categoryListView: RewardCategoryListView = { [unowned self] in
        let view = RewardCategoryListView()
        view.frame = CGRect(x: -80, y: 10, width: 80, height: 32 * 8)
        view.delegate = self
        view.loadData()
        return view
    }()
    
    var data: [Reward] = [] {
        didSet{
            MBProgressHUD.hide(for: view, animated: true)
            collectionView.reloadData()
        }
    }
    var selectedIndex: IndexPath? = nil
    
    //MARK: Function
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.addSubview(logoView)
        navigationController?.navigationBar.addSubview(filterButton)
        navigationController?.navigationBar.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(showAllButton)
        view.addSubview(categoryListView)
        autolayout()
        setupNaviBar()
        MBProgressHUD.showAdded(to: view, animated: true)
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logoView.isHidden = false
        searchBar.isHidden = true
        filterButton.isHidden = false
        searchButton.setImage(UIImage(named: "Search"), for: .normal)
        if selectedIndex != nil {
            collectionView.reloadItems(at: [selectedIndex!])
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logoView.isHidden = true
        searchBar.isHidden = true
        filterButton.isHidden = true
        categoryListView.show(false)
    }
    
    
    func setupNaviBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = UIColor.darkGray
    
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: .regular)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        let rightBarButton = UIBarButtonItem(customView: searchButton)
        navigationItem.rightBarButtonItem = rightBarButton
        searchButton.addTarget(self, action: #selector(searchButtonDidTouch(sender:)), for: .touchUpInside)
        
        filterButton.addTarget(self, action: #selector(filterButtonDidTouch(sender:)), for: .touchUpInside)
    }
    
    func autolayout(){
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        showAllButton.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    func loadData() {
        RewardManager.shared.loadData(at: view) { (allData) in
            self.data = allData
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logoView.center = CGPoint(x: Const.SCREEN_WIDTH / 2, y: Const.NAVIBAR_HEIGHT / 2)
        searchBar.frame = CGRect(x: 10, y: 0, width: Const.SCREEN_WIDTH - 60, height: 44)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
}

// MARK: - Button Action
extension RewardListViewController {
    @objc func searchButtonDidTouch(sender: Any) {
        if searchBar.isHidden {
            categoryListView.show(false)
            searchButton.setImage(UIImage(named: "redClose"), for: .normal)
            searchBar.alpha = 0.0
            searchBar.isHidden = false
            UIView.animate(withDuration: 0.15, animations: {
                self.logoView.alpha = 0.0
                self.searchBar.alpha = 1.0
            }, completion: { (_) in
                self.logoView.isHidden = true
                self.logoView.alpha = 1.0
                self.searchBar.becomeFirstResponder()
            })
        }else{
            searchButton.setImage(UIImage(named: "Search"), for: .normal)
            searchBar.resignFirstResponder()
            logoView.alpha = 0.0
            logoView.isHidden = false
            UIView.animate(withDuration: 0.15, animations: {
                self.searchBar.alpha = 0.0
                self.logoView.alpha = 1.0
            }, completion: { (_) in
                self.searchBar.isHidden = true
                self.searchBar.alpha = 1.0
            })
        }
    }
    
    @objc func showAllButtonDidTouch(sender: Any) {
        MBProgressHUD.showAdded(to: view, animated: true)
        loadData()
        showAllButton.isHidden = true
        categoryListView.show(false)
        categoryListView.selecetRow = nil
        collectionView.contentInset = UIEdgeInsetsMake(2, 2, 0, 2)
    }
    
    @objc func filterButtonDidTouch(sender: Any) {
        let show = categoryListView.frame.origin.x > 0 ? false : true
        categoryListView.show(show)
        categoryListView.tableView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension RewardListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? RewardCollectionViewCell {
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
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
        let vc = RewardDetailViewController()
        vc.data = data[indexPath.item]
        selectedIndex = indexPath
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard categoryListView.frame.origin.x > 0 else { return }
        categoryListView.show(false)
    }
}

// MARK: - UISearchBarDelegate
extension RewardListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard searchBar.text != nil else { return }
        guard searchBar.text!.count > 0 else {
            data = RewardManager.shared.allData
            collectionView.reloadData()
            return
        }
        guard searchBar.text!.trimmingCharacters(in: .whitespaces).isEmpty == false else { return }
        MBProgressHUD.showAdded(to: view, animated: true)
        let text = searchBar.text!.lowercased()
        DispatchQueue.global().async {
            var searchResult = [Reward]()
            for reward in RewardManager.shared.allData {
                if reward.key.lowercased() == text {
                    searchResult.removeAll()
                    searchResult.append(reward)
                    break
                }else if reward.name.lowercased().range(of: text) != nil {
                    searchResult.append(reward)
                }
            }
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: false)
                self.data = searchResult
                self.collectionView.reloadData()
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.mode = .text
                hud.label.text = self.data.count > 0 ? "\(self.data.count)件の結果を見つかりました" : "結果を見つかりませんでした"
                hud.hide(animated: true, afterDelay: 1.5)
                self.showAllButton.isHidden = (self.data.count == RewardManager.shared.allData.count)
                let bottomInset:CGFloat = (self.data.count == RewardManager.shared.allData.count) ? 0 : 44
                self.collectionView.contentInset = UIEdgeInsetsMake(2, 2, bottomInset, 2)
            }
        }
    }
}
// MARK: - RewardFilterDelegate
extension RewardListViewController: RewardCategoryListViewDelegate {
    func categorySelected(_ category: String) {
        data = RewardManager.shared.allData.filter{ $0.category == category }
        categoryListView.show(false)
        showAllButton.isHidden = false
        collectionView.contentInset = UIEdgeInsetsMake(2, 2, 44, 2)
    }
}
