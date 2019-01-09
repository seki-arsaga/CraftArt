//
//  SearchViewController.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/04.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit
import Firebase

class SearchViewController: BaseCollectionViewController<SearchViewCell, User>, UISearchBarDelegate {
    
    lazy var searchBar: UISearchBar = {
       let sb = UISearchBar()
        sb.placeholder = "ユーザーを検索"
        sb.delegate = self
        return sb
    }()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredUsers = items
        }else {
            filteredUsers = self.items.filter { (user) -> Bool in
                return user.nickname.lowercased().contains(searchText.lowercased())
            }
        }
        collectionView.reloadData()
    }
    
    fileprivate func setupSearchBar() {
        navigationController?.navigationBar.addSubview(searchBar)
        let navBar = navigationController?.navigationBar
        searchBar.anchor(top: navBar?.topAnchor, bottom: navBar?.bottomAnchor, left: navBar?.leftAnchor, right: navBar?.rightAnchor, paddingTop: 2, paddingBottom: -2, paddingLeft: 8, paddingRight: -8, width: 0, height: 0)
    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupSearchBar()
        fetchUserInfoFromFB()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }
    
    var filteredUsers = [User]()
    fileprivate func fetchUserInfoFromFB() {
        let dataRef = Database.database().reference().child("users")
        dataRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            dictionary.forEach({ (key, value) in
                
                if key == Auth.auth().currentUser?.uid {
                    return
                }
                
                guard let userDictionary = value as? [String: Any] else { return }
                let user = User.init(uid: key, dictionary: userDictionary)
                self.items.append(user)
            })
            
            self.items.sort(by: { (u1, u2) -> Bool in
                return u1.nickname.compare(u2.nickname) == .orderedAscending
            })
            
            self.filteredUsers = self.items
            self.collectionView.reloadData()
            
        }) { (err) in
            print("Failed to fetch user info: ", err)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 80)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchViewCell
        cell.item = filteredUsers[indexPath.item]
        
        return cell
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
