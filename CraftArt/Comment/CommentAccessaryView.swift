//
//  CommentAccessaryView.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/11.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

protocol CommentAccessoryViewDelegate {
    func didTapSentButton(for comment: String)
    func didChangeTextField(for comment:String)
}

class CommentAccessoryView: UIView, UITextViewDelegate {
    
    var commentDelegate: CommentAccessoryViewDelegate?
    
    func endPostComment() {
        commentTextView.text = nil
        commentSendButton.isEnabled = false
        commentTextView.showPlaceholderLabel()
    }
    
    lazy var commentTextView: CustomMessageTextView = {
        let textView = CustomMessageTextView()
        textView.placeholderLabel.text = "  コメントを追加"
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.backgroundColor = UIColor.mainGray()
        textView.layer.cornerRadius = 6
        textView.layer.masksToBounds = true
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.rgb(red: 220, green: 220, blue: 220).cgColor
        textView.delegate = self
        return textView
    }()
    
    func textViewDidChange(_ textView: UITextView) {
        guard let comment = commentTextView.text else { return }
        commentDelegate?.didChangeTextField(for: comment)
    }
    
    lazy var commentSendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("投稿", for: .normal)
        button.isEnabled = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(handleCommentButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleCommentButton() {
        let message = commentTextView.text ?? ""
        commentSendButton.isEnabled = false
        commentDelegate?.didTapSentButton(for: message)
    }
    
    let lineSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        
        addSubview(commentSendButton)
        commentSendButton.anchor(top: topAnchor, bottom: bottomAnchor, left: nil, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: -8, width: 50, height: 0)
        commentSendButton.addTarget(self, action: #selector(handlePostButton), for: .touchUpInside)
        
        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, left: leftAnchor, right: commentSendButton.leftAnchor, paddingTop: 8, paddingBottom: -8, paddingLeft: 12, paddingRight: -8, width: 0, height: 0)
        
        addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: topAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    @objc func handlePostButton() {
        print("handling Post Button....")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
