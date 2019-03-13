//
//  CustomFirebase.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/05.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit
import Firebase

class CustomFirebase {
    
//    func fetchUserInfo(users: [Any], ) {
//        let dataRef = Database.database().reference().child("users")
//        dataRef.observeSingleEvent(of: .value, with: { (snapshot) in
//
//            guard let dictionary = snapshot.value as? [String: Any] else { return }
//            dictionary.forEach({ (key, value) in
//
//                print("key: ", key, "value: ", value)
//                if key == Auth.auth().currentUser?.uid {
//                    print("Found myself")
//                    return
//                }
//
//                guard let userDictionary = value as? [String: Any] else { return }
//                let user = User.init(dictionary: userDictionary)
//                users.append(user)
//            })
//
//            users.sort(by: { (u1, u2) -> Bool in
//                return u1.username.compare(u2.username) == .orderedAscending
//            })
//
//            filteredUsers = self.users
//            collecionView.reloadData()
//
//        }) { (err) in
//            print("Failed to fetch user info: ", err)
//        }
//    }
}
