//
//  UserViewController.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/02.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit
import Firebase

class UserController: BaseCollectionViewController<UserCell, Post>, UserHeaderDelegate {
    
    let headerId = "headerId"
    var user: User?
    var userId: String?
    var refreshController: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        fetchUserInfoFromFB()
        setupRefreshControl()
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        
        tabBarController?.tabBar.isHidden = false
    }
    
    fileprivate func setupRefreshControl() {
        refreshController = UIRefreshControl.init()
        collectionView.refreshControl = refreshController
        if refreshController.isRefreshing {
            self.collectionView.refreshControl?.endRefreshing()
        }else {
            refreshController.isEnabled = true
            refreshController.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: PostController.updateFeedNotificationName, object: nil)
    }
    
    @objc func handleUpdateFeed() {
        handleRefresh()
    }
    
    @objc func handleRefresh() {
        items.removeAll()
        fetchUserInfoFromFB()
    }
    
    fileprivate func setupNavBar() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "•••", style: .plain, target: self, action: #selector(handleOptionButton))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }

    @objc func handleOptionButton() {
        Alert.signOutAlert(title: "", message: "ログアウトしてもよろしいですか？", on: self)
    }
    
    fileprivate func fetchUserInfoFromFB() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        let ref = Database.database().reference().child("users").child(uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDic = snapshot.value as? [String: Any] else { return }
            self.user = User.init(uid: uid, dictionary: userDic)
            self.navigationItem.title = self.user?.nickname
            self.collectionView.reloadData()
            
            let followingRef = Database.database().reference().child("following").child(uid)
            followingRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let numberFollowings = snapshot.childrenCount
                self.user?.numberFollowings = Int(numberFollowings)
                
                let followersRef = Database.database().reference().child("followers").child(uid)
                followersRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    let numberFollowers = snapshot.childrenCount
                    self.user?.numberFollowers = Int(numberFollowers)
                    
                    self.paginatePosts(uid: uid)
                }, withCancel: { (err) in
                    print("Failed to fetch followers info...: ", err)
                })
            }, withCancel: { (err) in
                print("Failed to fetch following Info...: ", err)
            })
        }) { (err) in
            print("Failed to fetch user Info...: ", err)
        }
    }
    
    var isFinishingpaging = false
    fileprivate func paginatePosts(uid: String) {
        
        self.collectionView.refreshControl?.endRefreshing()

        let pagenateRef = Database.database().reference().child("posts").child(uid)
        var query = pagenateRef.queryOrdered(byChild: "creationDate")
        if items.count > 0 {
            let value = items.last?.creationDate.timeIntervalSince1970
            query = query.queryEnding(atValue: value)
        }
        
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            let numberPosts = snapshot.childrenCount
            self.user?.numberPosts = Int(numberPosts)
            
            guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            allObjects.reverse()
            
            let allPosts = allObjects.count
            self.user?.allPosts = allPosts
            
            if allPosts < 4 {
                self.isFinishingpaging = true
            }
            if self.items.count > 0 && allPosts > 0 {
                allObjects.removeFirst()
            }
            
            guard let user = self.user else { return }
            allObjects.forEach({ (snapshot) in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                var post = Post.init(user: user, dictionary: dictionary)
                post.postId = snapshot.key
                self.items.append(post)
            })
            
            self.collectionView.reloadData()
        }) { (err) in
            print("Failed to pagenate posts....: ", err)
        }
    }
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(UserHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! UserHeader
        header.user = self.user
        header.userHeaderDelegate = self
        
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did select item....")
    }
        
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 430)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 3
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if items.count != 0 {
            return items.count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserCell
        if !refreshController.isRefreshing {
            cell.item = items[indexPath.item]
        }
        return cell
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func didTapEditButton(for cell: UserHeader) {
        let layout = UICollectionViewFlowLayout()
        let profileController = ProfileController.init(collectionViewLayout: layout)
        present(profileController, animated: true, completion: nil)
    }
    
}
