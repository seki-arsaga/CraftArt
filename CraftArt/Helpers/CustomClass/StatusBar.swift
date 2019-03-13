//
//  StatusBar.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/04.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

class StatusBar {
    
    static func setStatusBar(view: UIView) {
        let width = UIWindow().frame.width
        let height = UIWindow().safeAreaLayoutGuide.layoutFrame.minY
        let statusBar = UIView(frame:CGRect(x: 0, y: 0, width: width, height: height))
        statusBar.backgroundColor = UIColor.rgb(red: 5, green: 42, blue: 112)
        view.addSubview(statusBar)
    }
    
    static func setStatusBarToPickerController(view: UIView) {
        let width = UIWindow().frame.width
        let height = UIWindow().safeAreaLayoutGuide.layoutFrame.minY
        let statusBar = UIView(frame:CGRect(x: 0, y: 0, width: width, height: height))
        statusBar.backgroundColor = .white
        view.addSubview(statusBar)
    }
}
