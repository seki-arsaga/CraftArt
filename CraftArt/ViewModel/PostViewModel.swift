//
//  PostViewModel.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/20.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import Foundation

class PostViewModel {
    
    let user: User
    let captions: String
    let imageUrl: String
    let creationDate: Date
    
    init(post: Post) {
        self.user = post.user
        self.captions = post.captions
        self.imageUrl = post.imageUrl
        self.creationDate = post.creationDate
    }
}
