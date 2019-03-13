//
//  ProfileController.swift
//  CraftArt
//
//  Created by YusuKe on 2019/01/07.
//  Copyright © 2019年 YusuKe. All rights reserved.
//

import UIKit

class ProfileController: UICollectionViewController {
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        tabBarController?.tabBar.isHidden = true
        
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! ProfileHeader
        
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProfileCell
        
        return cell
    }
    
//    let profileImageView: UIImageView = {
//        let iv = UIImageView()
//        iv.backgroundColor = .orange
//        iv.layer.cornerRadius = 100
//        iv.layer.masksToBounds = true
//
//        return iv
//    }()
//
//    fileprivate func setupUIViews() {
//        view.addSubview(profileImageView)
//        profileImageView.anchor(top: view.topAnchor, bottom: nil, left: nil, right: nil, paddingTop: 60, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 200, height: 200)
//        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//
//    }
    
}
