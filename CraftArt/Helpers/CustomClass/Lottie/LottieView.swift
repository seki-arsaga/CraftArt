//
//  LottieView.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/03.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

class CustomLottieView: LottieView {
    
    
    lazy var lottieImageView: LOTAnimationView = {
        let av = LOTAnimationView()
        av.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        av.contentMode = .scaleAspectFill
        av.clipsToBounds = true
        av.center = view.center
        av.setAnimation(named: "loading")
        av.loopAnimation = true
        av.play()
        
        return av
    }()
}
