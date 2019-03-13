//
//  LottieView.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/03.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit
import Lottie

class LoadingLottieView: LOTAnimationView {
    
    init(animationName: String) {
        super.init(frame: .zero)
        
        self.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.setAnimation(named: animationName)
        self.loopAnimation = true
        self.play()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
