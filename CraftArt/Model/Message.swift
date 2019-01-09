//
//  Message.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/09.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

struct Message {
    
    var userId: String?
    
    let profileImageUrl: String
    let text: String
    let fromId: String
    let toId: String
    let creationDate: Date
    
    init(userId: String, dictionary: [String: Any]) {
        self.userId = userId
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        
        let secondsfrom1970 = dictionary["timestamp"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsfrom1970)
    }
}
