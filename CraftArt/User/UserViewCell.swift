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
            
            entireImageView.loadImage(urlString: urlString)
        }
    }
    
    let entireImageView: CustomProfileImageView = {
       let iv = CustomProfileImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        let ev = UIVisualEffectView(effect: nil)
        ev.effect = UIBlurEffect(style: .regular)
        ev.frame = iv.frame
        iv.addSubview(ev)
        ev.fillSuperview()
        return iv
    }()
    
    let photoImageView: CustomProfileImageView = {
       let iv = CustomProfileImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let categoryLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.text = "カテゴリー: デッサン"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let commentLabel = CustomPostLabel.init(text: "コメント\n 10")
    let likeLabel = CustomPostLabel.init(text: "いいね\n 20")
    let tokentLabel = CustomPostLabel.init(text: "トークン\n 15")
    
    fileprivate func setupViews() {
        addSubview(entireImageView)
        addSubview(photoImageView)
        addSubview(categoryLabel)
        addSubview(commentLabel)
        
        entireImageView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        photoImageView.anchor(top: nil, bottom: nil, left: leftAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: 0, width: 120, height: 120)
        photoImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        categoryLabel.anchor(top: nil, bottom: bottomAnchor, left: photoImageView.rightAnchor, right: nil, paddingTop: 0, paddingBottom: -100, paddingLeft: 10, paddingRight: 0, width: 150, height: 30)
        setupStackView()
    }
    
    fileprivate func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [commentLabel, likeLabel,tokentLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        
        addSubview(stackView)
        stackView.anchor(top: categoryLabel.bottomAnchor, bottom: nil, left: photoImageView.rightAnchor, right: nil, paddingTop: -10, paddingBottom: 0, paddingLeft: 15, paddingRight: 0, width: 170, height: 50)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
