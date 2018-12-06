//
//  CustomPostLabel.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/03.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

class CustomPostLabel: UILabel {
    
    init(text: String) {
        super.init(frame: .zero)
        self.textColor = .black
        self.text = text
        self.textAlignment = .center
        self.font = UIFont.boldSystemFont(ofSize: 12)
        self.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
