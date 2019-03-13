//
//  MessageViewCell.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/09.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

class MessageCell: BaseCollectionViewCell<Message> {
    
    var messageController: MessageController?
    
    override var item: Message! {
        didSet {
            let urlString = item.profileImageUrl
            profileImageView.loadImage(urlString: urlString)
            
            let text = item.text
            textView.text = text
            
            let date = item.creationDate
            let dateString = dateFormatter.string(from: date)
            dateLabel.text = dateString
        }
    }
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.text = "Something Message here"
        tv.backgroundColor = UIColor.clear
        tv.isScrollEnabled = false
        return tv
    }()
    
    let profileImageView: CustomLoadImageView = {
        let iv = CustomLoadImageView()
        iv.layer.cornerRadius = 40 / 2
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(white: 0, alpha: 0.3)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    let dateFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateStyle = .none
        format.timeStyle = .short
        format.locale = Locale(identifier: "ja_JP")
        return format
    }()
    
    lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        return imageView
    }()
    
    @objc func handleZoomTap(tapGesture: UITapGestureRecognizer) {
        if let imageView = tapGesture.view as? UIImageView {
            self.messageController?.performZoomInForImageView(startingImageView: imageView)
        }
    }
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleRightAnchor: NSLayoutConstraint?
    var bubbleLeftAnchor: NSLayoutConstraint?
    
    fileprivate func setupViews() {
        addSubview(profileImageView)
        addSubview(bubbleView)
        bubbleView.addSubview(textView)
        bubbleView.addSubview(dateLabel)
        bubbleView.addSubview(messageImageView)
        
        profileImageView.anchor(top: topAnchor, bottom: nil, left: leftAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 40, height: 40)
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        [
            bubbleWidthAnchor,
            bubbleRightAnchor,
            bubbleView.topAnchor.constraint(equalTo: self.topAnchor),
            bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor),
            ].forEach{ $0?.isActive = true }
        
        textView.anchor(top: bubbleView.topAnchor, bottom: bubbleView.bottomAnchor, left: bubbleView.leftAnchor, right: bubbleView.rightAnchor, paddingTop: 2, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0)
        dateLabel.anchor(top: nil, bottom: bubbleView.bottomAnchor, left: nil, right: bubbleView.rightAnchor, paddingTop: 0, paddingBottom: -2, paddingLeft: 0, paddingRight: -2, width: 50, height: 20)
        messageImageView.anchor(top: bubbleView.topAnchor, bottom: bubbleView.bottomAnchor, left: bubbleView.leftAnchor, right: bubbleView.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
