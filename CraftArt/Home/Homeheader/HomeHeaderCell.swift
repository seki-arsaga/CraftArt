//
//  HomeViewHeaderCell.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/06.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

class HomeViewHeaderCell: UICollectionViewCell {
    
    var category: Category? {
        didSet {
            categoryLabel.text = category?.text.rawValue
            categoryLabel.backgroundColor = category?.backgroundColor
            categoryLabel.textColor = category?.textColor
            
            setupHorizontalBarViewAnimate()
        }
    }
    
    fileprivate func setupHorizontalBarViewAnimate() {
        if category?.isSelected == true {
            self.horizontalBarView.isHidden = false
        }else {
            horizontalBarView.isHidden = true
        }
    }
    
    var categoryLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        label.layer.borderColor = UIColor.mainBlue().cgColor
        label.layer.borderWidth = 1
        return label
    }()
    
    let horizontalBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainBlue()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var horizontalBarViewLeftAnchor: NSLayoutConstraint?
    var horizontalBarViewRightAnchor: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(categoryLabel)
        addSubview(horizontalBarView)
        categoryLabel.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        horizontalBarViewLeftAnchor = horizontalBarView.leftAnchor.constraint(equalTo: categoryLabel.leftAnchor, constant: 5)
        horizontalBarViewRightAnchor = horizontalBarView.rightAnchor.constraint(equalTo: categoryLabel.rightAnchor, constant: -5)
        horizontalBarViewLeftAnchor?.isActive = true
        horizontalBarViewRightAnchor?.isActive = true
        [
            horizontalBarView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 5),
            horizontalBarView.heightAnchor.constraint(equalToConstant: 1)
            ].forEach{ $0.isActive = true }
        
//        horizontalBarView.anchor(top: categoryLabel.bottomAnchor, bottom: nil, left: categoryLabel.leftAnchor, right: categoryLabel.rightAnchor, paddingTop: 5, paddingBottom: 0, paddingLeft: 3, paddingRight: -3, width: 0, height: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
