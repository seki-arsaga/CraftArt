//
//  Alert.swift
//  CraftArt
//
//  Created by YusuKe on 2018/11/30.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit
import Firebase

struct Alert {
    
    static func showBasicAlert(title: String, message: String, on vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func signOutAlert(title: String, message: String, on vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ログアウト", style: .default, handler: { (action) in
            do {
                try Auth.auth().signOut()
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                vc.present(navController, animated: true, completion: nil)
            }catch let signOutError {
                print("Failed to sign out: ", signOutError)
            }
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func postAlert(title: String, message: String, on vc: UIViewController, handeler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "投稿", style: .default, handler: handeler))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
}

extension String {
    
    var isValidEmail : Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
}


