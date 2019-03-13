//
//  CommentController.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/11.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit
import Firebase

class CommentController: BaseCollectionViewController<CommentCell, Comment>, CommentAccessoryViewDelegate {
    
    var post: Post?
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.keyboardDismissMode = .interactive
        collectionView.alwaysBounceVertical = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        
        setupCollectionView()
        fetchPostCommentFromDB()
    }
    
    fileprivate func fetchPostCommentFromDB() {
        let postId = post?.postId ?? ""
        let commentRef = Database.database().reference().child("comments").child(postId)
        
        commentRef.observe( .childAdded, with: { (snapshot) in
            guard let dic = snapshot.value as? [String: Any] else { return }
            guard let uid = dic["uid"] as? String else { return }
            
            Database.fetchUserWithUID(uid: uid, completion: { (user) in
                let comment = Comment.init(user: user, dictionary: dic)
                self.items.append(comment)
                self.collectionView.reloadData()
            })
            
        }) { (err) in
            print("Failed to observe comments from DB: ", err)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.item = items[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        let height = max(50 + 8 + 8, estimatedSize.height)
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    lazy var containerView: CommentAccessoryView = {
       let view = CommentAccessoryView()
        view.commentDelegate = self
        return view
    }()
    
    func didTapSentButton(for comment: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let postId = self.post?.postId ?? ""
        
        if comment != "" {
            let values = ["text": comment, "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String : Any]
            let commentRef = Database.database().reference().child("comments").child(postId).childByAutoId()
            commentRef.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to updateChildValue..: ", err)
                    return
                }
                print("Successfully to updated comment")
                self.containerView.endPostComment()
            }
        }
    }
    
    func didChangeTextField(for comment: String) {
        let isTextValue = comment.count > 0
        if isTextValue {
            containerView.commentSendButton.isEnabled = true
        }else {
            containerView.commentSendButton.isEnabled = false
        }
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }

}
