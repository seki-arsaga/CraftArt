//
//  CustomProfileImageView.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/02.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomLoadImageView: UIImageView {
    
    var lastURLUsedToLoadImage: String?
    
    func loadImage(urlString: String) {
        lastURLUsedToLoadImage = urlString
        
        if let cacheImage = imageCache[urlString] {
            self.image = cacheImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to get fetch profile image: ", err)
            }
            
            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }
            
            guard let imageData = data else { return }
            let photoImage = UIImage(data: imageData)
            
            imageCache[url.absoluteString] = photoImage
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
            }.resume()
    }
}

class LoadingImageView : UIImageView {
    
    init(view: UIView) {
        super.init(frame: .zero)
        self.backgroundColor = .white
        self.frame = CGRect(x: 0, y: 20, width: view.frame.width, height: view.frame.height)
        let loadingView = LoadingLottieView.init(animationName: "loading")
        self.addSubview(loadingView)
        loadingView.center = view.center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
