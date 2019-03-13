//
//  Post.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/03.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

struct Post {
    
    var postId: String?
    var hasliked = false
    var countLikes: Int?
    var countComments: Int?
    
    let user: User
    let captions: String
    let imageUrl: String
    let creationDate: Date
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.captions = dictionary["captions"] as? String ?? ""
        self.imageHeight = dictionary["height"] as? NSNumber
        self.imageWidth = dictionary["witdh"] as? NSNumber
        
        let secondsFrom1970 = dictionary["createdDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
