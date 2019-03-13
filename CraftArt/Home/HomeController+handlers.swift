//
//  HomeViewExtension.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/11.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit
import Firebase

extension HomeController: HomeCellDelegate, HomeUserProfileCellDelegate {
    
    func didTapCell(for text: String) {
        navigationItem.title = text
    }
    
    func didTapLikeButton(for cell: HomeCell) {
        guard let index = collectionView.indexPath(for: cell) else { return }
        
        var post = items[index.item - 1]
        guard let postId = post.postId else { return }
        guard let postUID = post.user.uid else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let likeRef = Database.database().reference().child("likes").child(postUID).child(postId)
        let value = [uid: post.hasliked == true ? 0 : 1]
        if post.hasliked == true {
            post.countLikes! -= 1
        }else {
            post.countLikes! += 1
        }
        likeRef.updateChildValues(value) { (err, ref) in
            if let err = err {
                print("Failed to update like: ", err)
                return
            }
            post.hasliked = !post.hasliked
            self.items[index.item - 1] = post
            self.collectionView.reloadData()
        }
    }
    
    func didSelectItem(uid: String) {
        let userController = UserController.init(collectionViewLayout: UICollectionViewFlowLayout())
        userController.userId = uid
        self.navigationController?.pushViewController(userController, animated: true)
    }
    
    func profilePanGesture(uid: String, sender: UITapGestureRecognizer) {
        let userController = UserController.init(collectionViewLayout: UICollectionViewFlowLayout())
        userController.userId = uid
        self.navigationController?.pushViewController(userController, animated: true)
    }
    
    func didTapMessageButton(post: Post) {
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        let messageController = MessageController.init(collectionViewLayout: layout)
        messageController.user = post.user
        navigationController?.pushViewController(messageController, animated: true)
    }
    
    func didTapCommentButton(post: Post) {
        let commentController = CommentController.init(collectionViewLayout: UICollectionViewFlowLayout())
        commentController.post = post
        navigationController?.pushViewController(commentController, animated: true)
    }
    
    func didTapOptionButton(post: Post) {
        optionLauncher.showSettings()
    }
    
}
