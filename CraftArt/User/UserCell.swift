//
//  UserViewControllerCell.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/02.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

class UserViewCell: BaseCollectionViewCell<Post> {
    
    override var item: Post? {
        didSet {
            guard let urlString = item?.imageUrl else { return }
            photoImageView.loadImage(urlString: urlString)
        }
    }

    let photoImageView: CustomLoadImageView = {
       let iv = CustomLoadImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    fileprivate func setupViews() {
        addSubview(photoImageView)
        
        photoImageView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
