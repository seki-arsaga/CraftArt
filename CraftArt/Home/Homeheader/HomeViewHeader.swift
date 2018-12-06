//
//  HomeViewHeader.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/06.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

class HomeViewHeader: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let cellId = "cellId"
    
    override class var layerClass: AnyClass {
        get { return CustomLayer.self }
    }
    
    lazy var collecionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    fileprivate func setupCollectionView() {
        addSubview(collecionView)
        collecionView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        collecionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collecionView.showsHorizontalScrollIndicator = false
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .purple
        
        return cell
    }
    
    
}
