//
//  OptionLauncher.swift
//  CraftArt
//
//  Created by YusuKe on 2019/01/08.
//  Copyright © 2019年 YusuKe. All rights reserved.
//

import UIKit

class OptionLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {

    let blackView = UIView()
    let cellId = "cellId"
    var homeController: HomeController?
    
    lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .red
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        return cv
    }()
    
    @objc func showSettings() {
        //show menu
        
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
//            let height: CGFloat = CGFloat(settings.count) * cellHeight
//            let y = window.frame.height - height
            let height = window.frame.height / 2
            
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                
            }, completion: nil)
        }
    }
    
    @objc func handleTap() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .green
        
        return cell
    }
    
    
}
