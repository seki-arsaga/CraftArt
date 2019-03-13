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
            setupDate()
        }
    }
    
    fileprivate func setupDate() {
        let today = Date(timeIntervalSince1970: Date().timeIntervalSince1970)
        let todayString = dateFormatter.string(from: today)
        
        let yesterday = Date(timeInterval: -60 * 60 * 24, since: today)
        let yesterdayString = dateFormatter.string(from: yesterday)
        
        guard let date = date?.first?.creationDate else { return }
        let dateString = dateFormatter.string(from: date)
        
        if dateString == todayString {
            dateLabel.text = "今日"
        }else if dateString == yesterdayString {
            dateLabel.text = "昨日"
        }else {
            dateLabel.text = dateString
        }
        
        let text = dateLabel.text
        let width = estimateFrameForText(text: text!).width + 16
        dateLabelWidth?.constant = width
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = UIColor(white: 0, alpha: 0.3)
        label.textAlignment = .center
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dateString: String?
    let dateFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "MM/dd(EEE)"
        format.locale = Locale(identifier: "ja_JP")
        return format
    }()
    
    var dateLabelWidth: NSLayoutConstraint!
    fileprivate func setupViews() {
        addSubview(dateLabel)
        dateLabelWidth = dateLabel.widthAnchor.constraint(equalToConstant: 0)
        [
            dateLabelWidth,
            dateLabel.heightAnchor.constraint(equalToConstant: 30),
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ].forEach{ $0.isActive = true }
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
