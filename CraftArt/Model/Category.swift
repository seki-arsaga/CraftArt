//
//  Category.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/03.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

enum CategoryName: String {
    case 話題
    case 水彩画
    case 油絵
    case デッサン
    case 色鉛筆画
    case 切り絵
    case チョークアート
}

struct Category {
    
    let text: CategoryName
    var backgroundColor: UIColor?
    var textColor: UIColor?
    var isSelected: Bool?
    
    init(text: CategoryName, backgroundColor: UIColor, textColor: UIColor,  isSelected: Bool) {
        self.text = text
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.isSelected = isSelected
    }
}
