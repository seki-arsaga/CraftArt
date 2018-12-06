//
//  ByCategoryHeader.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/03.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit
import Firebase

class ByCategoryHeader: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var users = [User]()
    
    override class var layerClass: AnyClass {
        get { return CustomLayer.self }
    }
    
    lazy var collecionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    fileprivate func setupCollectionView() {
        addSubview(collecionView)
        collecionView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        collecionView.register(ByCategoryHeaderCell.self, forCellWithReuseIdentifier: cellId)
        collecionView.showsHorizontalScrollIndicator = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCollectionView()
        fetchUserInfoFromFB()
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
                let user = User.init(dictionary: userDictionary)
                self.users.append(user)
            })
            
            self.users.sort(by: { (u1, u2) -> Bool in
                return u1.username.compare(u2.username) == .orderedAscending
            })
            
            self.filteredUsers = self.users
            self.collecionView.reloadData()
            
        }) { (err) in
            print("Failed to fetch user info: ", err)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ByCategoryHeaderCell
        cell.user = users[indexPath.item]
        
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ByCategoryHeaderCell: UICollectionViewCell {
    
    var user: User? {
        didSet {
            guard let urlString = user?.imageUrl else { return }
            profileImageView.loadImage(urlString: urlString)
            profileImageBorderView.loadImage(urlString: urlString)
            
            guard let name = user?.nickname else { return }
            nameLabel.text = name
        }
    }
    
    let profileImageView: CustomProfileImageView = {
        let iv = CustomProfileImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 33
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
       return iv
    }()
    
    let profileImageBorderView: CustomProfileImageView = {
       let iv = CustomProfileImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 35
        iv.layer.masksToBounds = true
        let ev = UIVisualEffectView(effect: nil)
        ev.effect = UIBlurEffect(style: .regular)
        ev.frame = iv.frame
        iv.addSubview(ev)
        ev.fillSuperview()
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
       label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    fileprivate func setupViews() {
        addSubview(profileImageBorderView)
        addSubview(profileImageView)
        addSubview(nameLabel)
        profileImageBorderView.anchor(top: topAnchor, bottom: nil, left: leftAnchor, right: nil, paddingTop: 3, paddingBottom: 0, paddingLeft: 5, paddingRight: 0, width: 70, height: 70)
        [
            profileImageView.centerXAnchor.constraint(equalTo: profileImageBorderView.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: profileImageBorderView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 66),
            profileImageView.heightAnchor.constraint(equalToConstant: 66),
            ].forEach{ $0.isActive = true }
        nameLabel.anchor(top: profileImageBorderView.bottomAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 3, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 20)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
