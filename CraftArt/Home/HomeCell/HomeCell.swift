//
//  HomeControllerCell.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/02.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

protocol HomeCellDelegate {
    func didTapLikeButton(for  cell:HomeCell)
    func didTapMessageButton(post: Post)
    func didTapCommentButton(post: Post)
    func didTapOptionButton(post: Post)
    func postImagePinchGesture(imageView: UIImageView, sender: UIPinchGestureRecognizer)
    func profilePanGesture(uid: String, sender: UITapGestureRecognizer)
}

class HomeCell: BaseCollectionViewCell<Post> {
    
    var homeCellDelegate: HomeCellDelegate?
    var postImageHeight: CGFloat = 50
    
    override var item: Post! {
        didSet {
            let profileUrlString = item.user.imageUrl
            userImageView.loadImage(urlString: profileUrlString)
            
            let postUrlString = item.imageUrl
            postImageView.loadImage(urlString: postUrlString)
            
            let username = item.user.nickname
            usernameLable.text = username
            
            setupLikeButton(hasliked: true)
            
            let timeAgoDisplay = item.creationDate.timeAgoDisplayForJP()
            dateLabel.text = timeAgoDisplay
            
            let likes = item.countLikes ?? 0
            likesLabel.text = "いいね!  \(likes)件"
            
            let comments = item.countComments ?? 0
            commentLabel.text = "コメント \(comments)件"
            
            setupAttributedText(post: item)
            
            if let imageWidth = item.imageWidth?.floatValue, let imageHeight = item.imageHeight?.floatValue {
                postImageHeight = CGFloat(imageHeight / imageWidth * 200)
            }
        }
    }
    
    fileprivate func setupAttributedText(post: Post) {
        let username = post.user.nickname
        let postText = post.captions
        
        let attributedText = NSMutableAttributedString(attributedString: NSAttributedString(string: username, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]))
        attributedText.append(NSAttributedString(string: " " + postText, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        
        textView.attributedText = attributedText
    }
    
    fileprivate func setupLikeButton(hasliked: Bool) {
        self.likeButton.setImage(self.item.hasliked == hasliked ? UIImage(named: "heart_selected")?.resize(size: CGSize(width: 25, height: 25))?.withRenderingMode(.alwaysOriginal) : UIImage(named: "heart_unselected")?.resize(size: CGSize(width: 25, height: 25))?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    lazy var postImageView: CustomLoadImageView = {
       let iv = CustomLoadImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    lazy var userImageView: CustomLoadImageView = {
       let iv = CustomLoadImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 25
        iv.layer.masksToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    lazy var usernameLable: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .black
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let textView: UITextView = {
       let text = UITextView()
        text.font = UIFont.systemFont(ofSize: 14)
        text.textColor = .black
        text.isEditable = false
        return text
    }()
    
    lazy var optionButton: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleOptionButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleOptionButton() {
        homeCellDelegate?.didTapOptionButton(post: item)
    }
    
    let separateImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        return iv
    }()
    
    lazy var likeButton: UIButton = {
       let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.clipsToBounds = true
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()
    
    lazy var messageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "message_icon")?.resize(size: CGSize(width: 25, height: 25))?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.clipsToBounds = true
        button.addTarget(self, action: #selector(handleMessage), for: .touchUpInside)
        return button
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "comment_icon")?.resize(size: CGSize(width: 25, height: 25))?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.clipsToBounds = true
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return button
    }()
    
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .lightGray
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleComment)))
        return label
    }()
    
    let dateLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor(white: 0, alpha: 0.2)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    @objc func handleMessage() {
        homeCellDelegate?.didTapMessageButton(post: item)
    }
    
    @objc func handleComment() {
        homeCellDelegate?.didTapCommentButton(post: item)
    }
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [likeButton, commentButton])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 5
        return sv
    }()
    
    let likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
//        label.text = "....likes"
        return label
    }()
    
    @objc func handleLike() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.setupLikeButton(hasliked: false)
            self.likeButton.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        }) { (completed) in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.likeButton.layer.transform = CATransform3DMakeScale(1, 1, 1)
            }, completion: { (_) in
                self.homeCellDelegate?.didTapLikeButton(for: self)
            })
        }
    }
    
    fileprivate func setupViews() {
        addSubview(userImageView)
        addSubview(usernameLable)
        addSubview(optionButton)
        addSubview(postImageView)
        addSubview(stackView)
        addSubview(likesLabel)
        addSubview(textView)
        addSubview(separateImageView)
        addSubview(messageButton)
        addSubview(commentLabel)
        addSubview(dateLabel)
        bringSubviewToFront(postImageView)
        
        userImageView.anchor(top: topAnchor, bottom: nil, left: leftAnchor, right: nil, paddingTop: 13, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 50, height: 50)
        usernameLable.anchor(top: userImageView.topAnchor, bottom: nil, left: userImageView.rightAnchor, right: nil, paddingTop: 15, paddingBottom: 0, paddingLeft: 13, paddingRight: 0, width: 200, height: 0)
        optionButton.anchor(top: nil, bottom: postImageView.topAnchor, left: nil, right: rightAnchor, paddingTop: 0, paddingBottom: -10, paddingLeft: 0, paddingRight: -10, width: 20, height: 20)
        let width = frame.width
        postImageView.anchor(top: userImageView.bottomAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 5, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: width, height: width)
        postImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        separateImageView.anchor(top: bottomAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 3, paddingBottom: 0, paddingLeft: 20, paddingRight: 0, width: 0, height: 1)
        stackView.anchor(top: postImageView.bottomAnchor, bottom: nil, left: leftAnchor, right: nil, paddingTop: 5, paddingBottom: 0, paddingLeft: 10, paddingRight: 0, width: 100, height: 30)
        likesLabel.anchor(top: stackView.bottomAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 5, paddingBottom: 0, paddingLeft: 15, paddingRight: -10, width: 0, height: 15)
        textView.anchor(top: likesLabel.bottomAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 15, paddingRight: -10, width: 0, height: 40)
        messageButton.anchor(top: postImageView.bottomAnchor, bottom: nil, left: nil, right: rightAnchor, paddingTop: 5, paddingBottom: 0, paddingLeft: 0, paddingRight: -5, width: 50, height: 30)
        commentLabel.anchor(top: textView.bottomAnchor, bottom: nil, left: textView.leftAnchor, right: rightAnchor, paddingTop: 5, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 50)
        dateLabel.anchor(top: nil, bottom: bottomAnchor, left: leftAnchor, right: nil, paddingTop: 0, paddingBottom: -5, paddingLeft: 15, paddingRight: 0, width: 100, height: 20)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupPinchGesture()
        setupTapGesture()
    }
    
    fileprivate func setupTapGesture() {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        usernameLable.addGestureRecognizer(tap1)
    }

    fileprivate func setupPinchGesture() {
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        postImageView.addGestureRecognizer(pinch)
    }
    
    @objc func handlePinch(sender: UIPinchGestureRecognizer) {
        if let imageView = sender.view as? UIImageView {
            homeCellDelegate?.postImagePinchGesture(imageView: imageView, sender: sender)
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        guard let uid = item.user.uid else { return }
        homeCellDelegate?.profilePanGesture(uid: uid, sender: sender)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
