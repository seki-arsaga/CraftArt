//
//  User.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/02.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

struct User {
    
    var uid: String?
    
    let email: String
    let imageUrl: String
    let username: String
    let nickname: String
    var allPosts: Int?
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.email = dictionary["email"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.nickname = dictionary["nickname"] as? String ?? ""
    }
    
}
