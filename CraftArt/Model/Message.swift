//
//  Message.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/09.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

struct Message {
    
//    var userId: String?
    var user: User?
    
    let profileImageUrl: String
    let fromId: String
    let toId: String
    let creationDate: Date
    var text: String?
    var imageUrl: String?
    
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?
    
    init(dictionary: [String: Any]) {
//        self.user = user
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.text = dictionary["text"] as? String
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String
        self.imageHeight = dictionary["imageHeight"] as? NSNumber
        self.imageWidth = dictionary["imageWidth"] as? NSNumber
        
        let secondsfrom1970 = dictionary["timestamp"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsfrom1970)
    }
}
