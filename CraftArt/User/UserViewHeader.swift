//
//  UserViewControllerHeader.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/02.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

class UserViewHeader: UICollectionViewCell {
    
    var user: User? {
        didSet {
            guard let urlString = user?.imageUrl else { return }
            profileImageView.loadImage(urlString: urlString)
            
            guard let name = user?.nickname else { return }
            userNamelabel.text = name
        }
    }
    
    let entireImageView: UIImageView = {
       let iv = UIImageView()
        iv.backgroundColor = .gray
        return iv
    }()
    
    let profileImageView: CustomProfileImageView = {
        let iv = CustomProfileImageView()
        iv.layer.cornerRadius = 40
        iv.layer.masksToBounds = true
        iv.backgroundColor = .white
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let userNamelabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .white
        label.textAlignment = .right
        return label
    }()
    
    fileprivate func setupViews() {
        addSubview(entireImageView)
        addSubview(profileImageView)
        addSubview(userNamelabel)
        entireImageView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: -70, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        profileImageView.anchor(top: nil, bottom: entireImageView.bottomAnchor, left: nil, right: rightAnchor, paddingTop: 0, paddingBottom: -50, paddingLeft: 0, paddingRight: -20, width: 80, height: 80)
        userNamelabel.anchor(top: profileImageView.bottomAnchor, bottom: nil, left: nil, right: rightAnchor, paddingTop: 10, paddingBottom: 0, paddingLeft: 0, paddingRight: -30, width: 200, height: 30)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
