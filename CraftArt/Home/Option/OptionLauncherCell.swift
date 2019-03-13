//
//  OptionLauncherCell.swift
//  CraftArt
//
//  Created by YusuKe on 2019/01/08.
//  Copyright © 2019年 YusuKe. All rights reserved.
//

import UIKit

class OptionLauncherCell: UICollectionViewCell {
    
    var option: String! {
        didSet {
            optionNameLabel.text = option
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        setupUIViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let backView: UIImageView = {
       let view = UIImageView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 0.95)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let optionNameLabel: UILabel = {
       let label = UILabel()
        label.text = "Something here"
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
    
    fileprivate func setupUIViews() {
        addSubview(backView)
        addSubview(optionNameLabel)
        
        backView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 10, paddingRight: -10, width: 0, height: 0)
        optionNameLabel.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
}
