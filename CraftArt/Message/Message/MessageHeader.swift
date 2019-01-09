//
//  MessageViewHeader.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/09.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

class MessageHeader: UICollectionViewCell {
    
    var date: [Message]? {
        didSet {
            guard let date = date?.first?.creationDate else { return }
            let dateString = dateFormatter.string(from: date)
            
            dateLabel.text = dateString
        }
    }
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
//        label.text = dateString
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = UIColor(white: 0, alpha: 0.3)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        
        return label
    }()
    
    var dateString: String?
    let dateFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateStyle = .medium
        format.timeStyle = .none
        format.locale = Locale(identifier: "ja_JP")
        return format
    }()
    
    fileprivate func setupViews() {
        addSubview(dateLabel)
        dateLabel.anchor(top: nil, bottom:nil, left: nil, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 90, height: 30)
        dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
