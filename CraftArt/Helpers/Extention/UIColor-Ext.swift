//
//  Extentions.swift
//  TestOfApp
//
//  Created by YusuKe on 2018/10/24.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func mainBlue() -> UIColor {
        return UIColor.rgb(red: 5, green: 42, blue: 112)
    }
    
    static func mainGray() -> UIColor {
        return UIColor.rgb(red: 230, green: 230, blue: 230)
    }
    
}

extension CAGradientLayer {
    static func signInBackgroundColor(frame: CGRect) -> CAGradientLayer {
        let topColor = UIColor.rgb(red: 5, green: 42, blue: 112).cgColor
        let bottomColor = UIColor.rgb(red: 255, green: 150, blue: 30).cgColor
        let gradientColor = [topColor, bottomColor]
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = gradientColor
        gradientLayer.frame = frame
        return gradientLayer
    }
}
