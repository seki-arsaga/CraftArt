//
//  CustomButton.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/04.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

class PostPhotoButton: UIButton {
    
    init(type buttonType: UIButton.ButtonType, image: UIImage, target: Any ,selector: Selector) {
        super.init(frame: .zero)
        self.setTitle("画像を選択", for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        self.imageView?.contentMode = .scaleAspectFill
        self.imageView?.clipsToBounds = true
        self.layer.masksToBounds = true
        self.backgroundColor = .gray
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
        self.addTarget(target, action: selector, for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RegisterButton: UIButton {
    
    override var buttonType: UIButton.ButtonType {
        return .system
    }
    
    init(title: String, target: Any, selector: Selector) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(UIColor.rgb(red: 135, green: 156, blue: 188), for: .normal)
        self.backgroundColor = UIColor.rgb(red: 129, green: 175, blue: 249)
        self.isEnabled = false
        self.layer.cornerRadius = 5
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.addTarget(target, action: selector, for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
