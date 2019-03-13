//
//  CommentCell.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/11.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

class CommentCell: BaseCollectionViewCell<Comment> {
    
    override var item: Comment! {
        didSet {
            setupAttributedText(comment: item)
            
            let urlString = item.user.imageUrl
            profileImageView.loadImage(urlString: urlString)
        }
    }
    
    fileprivate func setupAttributedText(comment: Comment) {
        let username = comment.user.nickname
        let commentText = comment.text
        let timeAgoText = comment.creationDate.timeAgoDisplayForJP()
        
        let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: username, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]))
        attributedText.append(NSAttributedString(string: " " + commentText, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 5)]))
        attributedText.append(NSAttributedString(string: timeAgoText, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        
        textView.attributedText = attributedText
    }
    
    let profileImageView: CustomLoadImageView = {
        let iv = CustomLoadImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 40 / 2
        iv.layer.masksToBounds = true
        return iv
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
//        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
    }()
    
    let lineSeparatorView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .mainGray()
        return view
    }()
    
    fileprivate func setupViews() {
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, bottom: nil, left: leftAnchor, right: nil, paddingTop: 8, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 40, height: 40)
        
        addSubview(textView)
        textView.anchor(top: topAnchor, bottom: bottomAnchor, left: profileImageView.rightAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: -4, width: 0, height: 0)
        
        addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: bottomAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 60, paddingRight: -2, width: 0, height: 0.5)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
