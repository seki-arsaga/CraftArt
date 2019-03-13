//
//  MessageLogCell.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/13.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

class MessageLogCell: BaseTableViewCell<Message> {
    
    override var item: Message! {
        didSet {
            let urlString = item.user!.imageUrl
            profileImageView.loadImage(urlString: urlString)
            
            setuoMessageLable()
            
            let date = item.creationDate
            let dateString = date.timeAgoDisplayForJP()
            dateLabel.text = dateString
        }
    }
    
    fileprivate func setuoMessageLable() {
        let username = item.user!.nickname
        let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(username)\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16) ]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 3) ]))
        let text = item.text ?? "写真"
        attributedText.append(NSAttributedString(string: text, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        
        messageLabel.attributedText = attributedText
    }
    
    let profileImageView: CustomLoadImageView = {
        let iv = CustomLoadImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .green
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 25
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(white: 0, alpha: 0.2)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    fileprivate func setupViews() {
        addSubview(profileImageView)
        addSubview(messageLabel)
        addSubview(dateLabel)
        profileImageView.anchor(top: nil, bottom: nil, left: leftAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: 0, width: 50, height: 50)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        messageLabel.anchor(top: nil, bottom: nil, left: profileImageView.rightAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: 0, width: 200, height: 60)
        messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        dateLabel.anchor(top: topAnchor, bottom: nil, left: nil, right: rightAnchor, paddingTop: 6, paddingBottom: 0, paddingLeft: 0, paddingRight: -3, width: 60, height: 10)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupViews()
    }
    
}
