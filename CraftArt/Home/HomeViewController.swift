//
//  HomeController.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/01.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit
import Firebase

class HomeController: BaseCollectionViewController<HomeControllerCell>{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    fileprivate func setupNavBar() {
        navigationItem.title = "HOME"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "ログアウト", style: .plain, target: self, action: #selector(handleLeftButton))
    }
    
    @objc func handleLeftButton() {
        do {
            try Auth.auth().signOut()
            let loginController = LoginController()
            let navController = UINavigationController(rootViewController: loginController)
            self.present(navController, animated: true, completion: nil)
        }catch let signOutError {
            print("Failed to sign out: ", signOutError)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
}
