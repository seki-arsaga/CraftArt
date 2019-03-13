//
//  MainViewController.swift
//  CraftArt
//
//  Created by YusuKe on 2018/11/29.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit
import Firebase

class MainController: UITabBarController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let index = viewControllers?.lastIndex(of: viewController) {
            if index == 1 {
                let addPhotoViewController = AddPhotoController.init(collectionViewLayout: UICollectionViewFlowLayout())
                let navController = UINavigationController(rootViewController: addPhotoViewController)
                present(navController, animated: true, completion: nil)
                return false
            }
        }
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
                let navLoginController = UINavigationController(rootViewController: loginController)
                self.present(navLoginController, animated: true, completion: nil)
            }
            return
        }
        setupViewControllers()
    }
    
    fileprivate func setupViewControllers() {
        StatusBar.setStatusBar(view: view)
        let layout = UICollectionViewFlowLayout()
        let homeViewController = templateViewController(rootViewController: HomeController.init(collectionViewLayout: layout), unselected: "home_unselected", selected: "home_selected")
        
        let addPhotoViewController = templateViewController(rootViewController: AddPhotoController.init(collectionViewLayout: UICollectionViewFlowLayout()), unselected: "upload_unselected", selected: "upload_selected")
        
        let userViewController = templateViewController(rootViewController: UserController.init(collectionViewLayout: UICollectionViewFlowLayout()), unselected: "user_unselected", selected: "user_selected")
        
        let searchViewController = templateViewController(rootViewController: SearchController.init(collectionViewLayout: UICollectionViewFlowLayout()), unselected: "search_icon", selected: "search_icon")
        
        viewControllers = [homeViewController, addPhotoViewController, userViewController, searchViewController]
        
        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        }
        
    }
    
    fileprivate func templateViewController(rootViewController: UIViewController = UIViewController(), unselected: String, selected: String) -> UIViewController {
        let viewController = rootViewController
        let navViewController = UINavigationController.init(rootViewController: viewController)
        navViewController.tabBarItem.image = UIImage(named: unselected)?.resize(size: CGSize(width: 25, height: 25))!.withRenderingMode(.alwaysOriginal)
        navViewController.tabBarItem.selectedImage = UIImage(named: selected)?.resize(size: CGSize(width: 25, height: 25))!.withRenderingMode(.alwaysOriginal)
        
        return navViewController
    }
    
}
