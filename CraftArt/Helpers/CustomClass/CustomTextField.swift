//
//  CustomClassForSignIn.swift
//  CraftArt
//
//  Created by YusuKe on 2018/11/27.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

class SignInTextField: UITextField {
    
    init(placeholderText: String, selector: Selector, target: Any) {
        super.init(frame: .zero)
        self.backgroundColor = .white
        self.font = UIFont.systemFont(ofSize: 16)
        self.placeholder = placeholderText
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 10))
        self.borderStyle = .roundedRect
        self.addTarget(target, action: selector, for: .editingChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
