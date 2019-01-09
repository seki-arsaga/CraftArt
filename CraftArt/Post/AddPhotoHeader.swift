//
//  AddPhotoViewHeader.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/04.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

class AddPhotoViewHeader: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true        
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: -1, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
