//
//  Comment.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/11.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

class Comment {
    
    let user: User
    
    let text: String
    let uid: String
    let creationDate: Date
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
