//
//  SearchViewCell.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/04.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

class SearchCell: BaseCollectionViewCell<User> {
    
    override var item: User! {
        didSet {
            let urlString = item.imageUrl
            profileImageView.loadImage(urlString: urlString)
            
            let name = item.nickname
            usernameLabel.text = name
        }
    }
    
    let profileImageView: CustomLoadImageView = {
        let iv = CustomLoadImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 30
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Something"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let separateImageView: UIImageView = {
       let iv = UIImageView()
        iv.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return iv
    }()
    
    fileprivate func setupViews() {
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(separateImageView)
        profileImageView.anchor(top: nil, bottom: nil, left: leftAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: 0, width: 60, height: 60)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        usernameLabel.anchor(top: nil, bottom: nil, left: profileImageView.rightAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: 0, width: 200, height: 30)
        usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        separateImageView.anchor(top: bottomAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 30, paddingRight: -5, width: 0, height: 1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
