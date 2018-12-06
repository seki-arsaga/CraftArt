//
//  UINavigetionExtensions.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/03.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    override open var childForStatusBarStyle: UIViewController? {
        return self.visibleViewController
    }
    
    override open var childForStatusBarHidden: UIViewController? {
        return self.visibleViewController
    }
    
}


extension NotificationCenter {
    
    static func keyboardWillShow(selector: Selector, observer: Any) {
        self.default.addObserver(observer, selector: selector, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    static func keyboardWillHide(selector: Selector, observer: Any) {
        self.default.addObserver(observer, selector: selector, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

}
