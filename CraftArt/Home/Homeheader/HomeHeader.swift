//
//  HomeViewHeader.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/06.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

class HomeHeader: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var homeController: HomeController?
    
    override class var layerClass: AnyClass {
        get { return CustomLayer.self }
    }
    
    var categories = [
        Category.init(text: CategoryName.話題, backgroundColor: UIColor.mainBlue(), textColor: .white, isSelected: false),
        Category.init(text: CategoryName.水彩画, backgroundColor: UIColor.mainBlue(), textColor: .white, isSelected: false),
        Category.init(text: CategoryName.油絵, backgroundColor: UIColor.mainBlue(), textColor: .white, isSelected: false),
        Category.init(text: CategoryName.デッサン, backgroundColor: UIColor.mainBlue(), textColor: .white, isSelected: false),
        Category.init(text: CategoryName.色鉛筆画, backgroundColor: UIColor.mainBlue(), textColor: .white, isSelected: false),
        Category.init(text: CategoryName.切り絵, backgroundColor: UIColor.mainBlue(), textColor: .white, isSelected: false),
        Category.init(text: CategoryName.チョークアート, backgroundColor: UIColor.mainBlue(), textColor: .white, isSelected: false),
    ]
    
    lazy var collecionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    let separateImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        return iv
    }()
    
    fileprivate func setupCollectionView() {
        addSubview(collecionView)
        collecionView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        collecionView.register(HomeHeaderCell.self, forCellWithReuseIdentifier: cellId)
        collecionView.showsHorizontalScrollIndicator = false
        collecionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    fileprivate func setupSeparateImageView() {
        addSubview(separateImageView)
        separateImageView.anchor(top: bottomAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 1)
    }
    
    fileprivate func setupCategoryArray() {
        tempCategories = categories
        categories[0].backgroundColor = UIColor.white
        categories[0].textColor = .mainBlue()
        categories[0].isSelected = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCollectionView()
        setupSeparateImageView()
        setupCategoryArray()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = categories[indexPath.item].text
        let width = estimateFrameForText(text: text.rawValue).width + 20

        return CGSize(width: width, height: 35)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 200)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    var tempCategories = [Category]()
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categories = tempCategories
        
        if !categories[indexPath.item].isSelected! {
            categories[indexPath.item].backgroundColor = .white
            categories[indexPath.item].textColor = .mainBlue()
            categories[indexPath.item].isSelected = true
        }
        self.collecionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeHeaderCell
        cell.category = categories[indexPath.item]
        
        if categories[indexPath.item].isSelected != true {
            categories[indexPath.item].backgroundColor = .mainBlue()
            categories[indexPath.item].textColor = .white
        }
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
