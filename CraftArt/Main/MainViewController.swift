//
//  MainViewController.swift
//  CraftArt
//
//  Created by YusuKe on 2018/11/29.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UITabBarController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.delegate = self
        
        let uid = Auth.auth().currentUser?.uid
        if uid == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
            return
        }
        seupViewControllers()
    }
    
    fileprivate func seupViewControllers() {
        let homeViewController = HomeViewController.init(collectionViewLayout: UICollectionViewFlowLayout())
        let navHomeController = UINavigationController.init(rootViewController: homeViewController)
        navHomeController.tabBarItem.image = UIImage(named: "home_unselected")?.resize(size: CGSize(width: 30, height: 30))!.withRenderingMode(.alwaysOriginal)
        navHomeController.tabBarItem.selectedImage = UIImage(named: "home_selected")?.resize(size: CGSize(width: 30, height: 30))!.withRenderingMode(.alwaysOriginal)
        
        let userViewController = UserViewController.init(collectionViewLayout: UICollectionViewFlowLayout())
        let navUserViewController = UINavigationController.init(rootViewController: userViewController)
        navUserViewController.tabBarItem.image = UIImage(named: "user_unselected")?.resize(size: CGSize(width: 30, height: 30))!.withRenderingMode(.alwaysOriginal)
        navUserViewController.tabBarItem.selectedImage = UIImage(named: "user_selected")?.resize(size: CGSize(width: 30, height: 30))!.withRenderingMode(.alwaysOriginal)
        
        viewControllers = [navHomeController, navUserViewController]
        
        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        }
        
    }
    
}
