//
//  HomeControllerCell.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/02.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

class HomeViewControllerCell: BaseCollectionViewCell<Category> {
    
    override var item: Category! {
        didSet {
            categoryImageView.image = item.image
            categoryLabel.text = item.name
        }
    }
    
    let categoryImageView: UIImageView = {
       let iv = UIImageView()
        iv.backgroundColor = .red
        iv.layer.cornerRadius = 20
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let visualImageView: UIImageView = {
       let iv = UIImageView()
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        let ev = UIVisualEffectView(effect: nil)
        ev.effect = UIBlurEffect(style: .regular)
        ev.frame = iv.frame
        iv.addSubview(ev)
        ev.fillSuperview()
        return iv
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    fileprivate func setupViews() {
        addSubview(categoryImageView)
        addSubview(visualImageView)
        visualImageView.addSubview(categoryLabel)
        categoryLabel.fillSuperview()
        categoryImageView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 15, paddingBottom: -15, paddingLeft: 15, paddingRight: -15, width: 0, height: 0)
        visualImageView.anchor(top: nil, bottom: categoryImageView.bottomAnchor, left: nil, right: categoryImageView.rightAnchor, paddingTop: 0, paddingBottom: -10, paddingLeft: 0, paddingRight: -10, width: 130, height: 70)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
