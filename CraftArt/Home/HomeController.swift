//
//  HomeController.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/01.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit
import Firebase

class HomeController: BaseCollectionViewController<HomeCell, Post> {
    
    
    
    let myVar = GlobalVar.shared
    let headerId = "headerId"
    let userCellId = "userCellId"
    var refreshController: UIRefreshControl!
    
    lazy var homeHeader: HomeHeader = {
        let vh = HomeHeader()
        vh.homeController = self
        return vh
    }()
    
    fileprivate func setupNavBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .white
        navigationItem.title = "HOME"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.hidesBarsOnSwipe = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "message_icon")?.resize(size: CGSize(width: 30, height: 30)), style: .plain, target: self, action: #selector(handleRightBar))
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera_icon")?.resize(size: CGSize(width: 30, height: 30)), style: .plain, target: self, action: #selector(handleCamera))
        navigationItem.leftBarButtonItem!.tintColor = .white
    }
    
    @objc func handleCamera() {
        let cameraController = CameraController()
        present(cameraController, animated: true, completion: nil)
    }
    
    @objc func handleRightBar() {
        let messageLogController = MessageLogController()
        navigationController?.pushViewController(messageLogController, animated: true)
    }
    
    fileprivate func setupCollectionView() {
        collectionView.register(HomeUserProfileCell.self, forCellWithReuseIdentifier: userCellId)
        collectionView.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
    }
    
    fileprivate func setupHomeViewHeader() {
        let blueView = UIView()
        blueView.backgroundColor = UIColor.mainBlue()
        view.addSubview(blueView)
        blueView.anchor(top: view.topAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 60)
        
        view.addSubview(homeHeader)
        homeHeader.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 60)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
        setupNavBar()
        setupCollectionView()
        setupHomeViewHeader()
        fetchPost()
        fetchFollowingUserIds()
        setupUpdateFeed()
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
    }
    
    func setupUpdateFeed() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: PostController.updateFeedNotificationName, object: nil)
    }
    
    @objc func handleUpdateFeed() {
        handleRefresh()
    }
    
    @objc func handleRefresh() {
        items.removeAll()
        fetchPost()
        fetchFollowingUserIds()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.hidesBarsOnSwipe = true
    }
    
    fileprivate func fetchPost() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostInfoWithUser(user: user)
        }
    }
    
    fileprivate func fetchFollowingUserIds() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("following").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userIdDictionaries = snapshot.value as? [String: Any] else { return }
            
            userIdDictionaries.forEach({ (key, value) in
                Database.fetchUserWithUID(uid: key, completion: { (user) in
                    self.fetchPostInfoWithUser(user: user)
                })
            })
        }) { (err) in
            print("Failed to fetch followng user ids", err)
        }
    }
    
    fileprivate func fetchPostInfoWithUser(user: User) {
        self.collectionView.refreshControl?.endRefreshing()
        
        let postRef = Database.database().reference().child("posts").child(user.uid!)
        postRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dic = snapshot.value as? [String: Any] else { return }
            dic.forEach({ (key, value) in
                
                guard let postDic = value as? [String: Any] else { return }
                var post = Post.init(user: user, dictionary: postDic)
                post.postId = key
                
                let countRef = Database.database().reference().child("likes").child(key)
                countRef.observeSingleEvent(of: .value, with: { (snapshot) in
                  
                    let postLikesDic = snapshot.value as? [String: Int] ?? [key: 0]
                    let postLikes = postLikesDic.values
                    
                    let count = postLikes.reduce(0, {sum, number in sum + number})
                    post.countLikes = count
                    
                    self.fetchPostInfoAndSort(key: key, post: post)

                }, withCancel: { (err) in
                    print("Failed to fetch likes count")
                })
            })
        }) { (err) in
            print("Failed to fetch post Info from DB..")
        }
    }
    
    fileprivate func fetchPostInfoAndSort(key: String, post: Post) {
        var post = post
        let commentRef = Database.database().reference().child("comments").child(key)
        commentRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let countComments = snapshot.childrenCount
            post.countComments = Int(countComments)
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let likesRef = Database.database().reference().child("likes").child(key).child(uid)
            likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let liked = snapshot.value as? Int, liked == 1 {
                    post.hasliked = true
                }else {
                    post.hasliked = false
                }
                
                self.items.insert(post, at: 0)
                self.items.sort(by: { (p1, p2) -> Bool in
                    return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                })
                self.collectionView.reloadData()
                
            }, withCancel: { (err) in
                print("Failed to fetch user likes...")
            })
            
        }) { (err) in
            print("Failed to fetch comments: ", err)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: view.frame.width, height: 120)
        }
        return CGSize(width: view.frame.width, height: 600)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if items.count != 0 {
            return items.count + 1
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: userCellId, for: indexPath) as! HomeUserProfileCell
            cell.homeUserProfileCellDelegate = self
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeCell
        if !refreshController.isRefreshing {
            cell.item = items[indexPath.item - 1]
            cell.homeCellDelegate = self
        }
        
        return cell
    }
    
    func postImagePinchGesture(imageView: UIImageView, sender: UIPinchGestureRecognizer) {
        
        if sender.state == .began || sender.state == .changed {
            imageView.transform = imageView.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1.0
        }else if sender.state == .ended {
            imageView.transform = CGAffineTransform.identity
        }
    }
    
    lazy var optionLauncher: OptionLauncher = {
        let launcher = OptionLauncher()
        launcher.homeController = self
        
        return launcher
    }()
 
}
