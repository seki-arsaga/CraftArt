//
//  UserViewControllerHeader.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/02.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit
import Firebase

protocol UserHeaderDelegate {
    func didTapEditButton(for  cell:UserHeader)
}

enum Follow: String {
    case フォローする
    case フォロー中
}

class UserHeader: UICollectionViewCell {
    
    var userHeaderDelegate: UserHeaderDelegate?
    
    var user: User? {
        didSet {
            guard let urlString = user?.imageUrl else { return }
            profileImageView.loadImage(urlString: urlString)
            
            guard let name = user?.nickname else { return }
            userNamelabel.text = name
            
            setupEditFollowButton()
            templateAttributeText(label: followingLabel, user?.numberFollowings ?? 0, text: "フォロー中")
            templateAttributeText(label: followersLabel, user?.numberFollowers ?? 0, text: "フォロワー")
            templateAttributeText(label: postLabel, user?.numberPosts ?? 0, text: "投稿")
        }
    }
    
    fileprivate func templateAttributeText(label: UILabel, _ user: Int, text: String) {
        let count = user
        
        let attributeText = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(count)\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)]))
        attributeText.append(NSAttributedString(string: text, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.white]))
        label.attributedText = attributeText
    }
    
    fileprivate func setupEditFollowButton() {
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        guard let userId = self.user?.uid else { return }
        
        if currentUser == userId {
            editButton.setTitle("プロフィールを編集", for: .normal)
        }else {
            let ref = Database.database().reference().child("following").child(currentUser).child(userId)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                    self.setupUnFollowButton()
                }else {
                    self.setupFollowButton()
                }
                
            }) { (err) in
                print("Failed check if following: ", err)
            }
        }
    }
    
    @objc func profileFollwHandleFollow() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        let followingRef = Database.database().reference().child("following").child(currentUserId)
        let followedRef = Database.database().reference().child("followers").child(userId)
        
        if editButton.titleLabel?.text == Follow.フォロー中.rawValue {
            followingRef.child(userId).removeValue { (err, ref) in
                if let err = err {
                    print("Failed to unfollowing user: ", err)
                    return
                }
                
                followedRef.child(currentUserId).removeValue(completionBlock: { (err, ref) in
                    if let err = err {
                        print("Failed to unfollowes user: ", err)
                        return
                    }
                    print("Successfully to unfollow")
                    self.setupEditFollowButton()
                })
            }
            
        }else if editButton.titleLabel?.text == Follow.フォローする.rawValue{
            let followingValues = [userId: 1]
            followingRef.updateChildValues(followingValues) { (err, ref) in
                if let err = err {
                    print("Failed to following user:", err)
                    return
                }
                
                let followedValues = [currentUserId: 1]
                followedRef.updateChildValues(followedValues, withCompletionBlock: { (err, ref) in
                    if let err = err {
                        print("Failed to updated followed user:", err)
                        return
                    }
                    
                    print("Successfully to following user")
                    self.setupUnFollowButton()
//                    self.delegate?.reloadView()
                })
                
            }
        }else {
            self.userHeaderDelegate?.didTapEditButton(for: self)
        }
    }
    
    func setupFollowButton() {
        editButton.setTitle("フォローする", for: .normal)
        editButton.setTitleColor(.white, for: .normal)
        editButton.backgroundColor = .mainBlue()
    }
    
    func setupUnFollowButton(){
        editButton.setTitle(Follow.フォロー中.rawValue, for: .normal)
        editButton.setTitleColor(.mainBlue(), for: .normal)
        editButton.layer.borderColor = UIColor.mainBlue().cgColor
        editButton.layer.borderWidth = 1
        editButton.backgroundColor = .white
    }
    
    override class var layerClass: AnyClass {
        get { return CustomLayer.self }
    }
    
    let coverImageView: UIImageView = {
       let iv = UIImageView(image: UIImage(named: "cover_sample_image")?.withRenderingMode(.alwaysOriginal))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .white
        return iv
    }()
    
    let profileImageView: CustomLoadImageView = {
        let iv = CustomLoadImageView()
        iv.layer.cornerRadius = 40
        iv.layer.masksToBounds = true
        iv.backgroundColor = .white
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let userNamelabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainBlue()
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(profileFollwHandleFollow), for: .touchUpInside)
        return button
    }()
    
    let followingLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let postLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "投稿"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var followStackView: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [postLabel, followingLabel, followersLabel])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "grid")?.resize(size: CGSize(width: 30, height: 30)), for: .normal)
        button.addTarget(self, action: #selector(handleGridButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleGridButton() {
        
    }
    
    lazy var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "list")?.resize(size: CGSize(width: 30, height: 30)), for: .normal)
        button.addTarget(self, action: #selector(handleListButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleListButton() {
        
    }
    
    let separateBottomImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return iv
    }()
    
    let separateTopImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return iv
    }()
    
    fileprivate func setupViews() {
        addSubview(coverImageView)
        addSubview(followStackView)
        addSubview(profileImageView)
        addSubview(userNamelabel)
        addSubview(editButton)
        
        coverImageView.anchor(top: topAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 230)
        followStackView.anchor(top: nil, bottom: coverImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 100)
        profileImageView.anchor(top: coverImageView.bottomAnchor, bottom: nil, left: leftAnchor, right: nil, paddingTop: 10, paddingBottom: 0, paddingLeft: 20, paddingRight: 0, width: 80, height: 80)
        userNamelabel.anchor(top: profileImageView.bottomAnchor, bottom: nil, left: profileImageView.leftAnchor, right: nil, paddingTop: 5, paddingBottom: 0, paddingLeft: 5, paddingRight: 0, width: 200, height: 30)
        editButton.anchor(top: coverImageView.bottomAnchor, bottom: nil, left: nil, right: rightAnchor, paddingTop: 8, paddingBottom: 0, paddingLeft: 0, paddingRight: -8, width: 200, height: 30)
    }
    
    fileprivate func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        addSubview(separateTopImageView)
        addSubview(separateBottomImageView)
        stackView.anchor(top: nil, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 50)
        separateTopImageView.anchor(top: stackView.topAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 1)
        separateBottomImageView.anchor(top: nil, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupStackView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
