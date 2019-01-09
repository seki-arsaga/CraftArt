//
//  MessageAccessoryView.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/09.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

protocol MessageAccesoryViewDelegate {
    func didTapSentButton(for message: String)
    func didChangeTextField(for comment:String)
    func didTapPhotoButton()
}

class MessageAccessoryView: UIView, UITextViewDelegate {
    
    var messageDelegate: MessageAccesoryViewDelegate?
    
    func endMessage() {
        messageTextView.text = nil
        messageSendButton.isEnabled = false
        messageTextView.showPlaceholderLabel()
    }
    
    let containerView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        return iv
    }()
    
    lazy var messageTextView: CustomMessageTextView = {
        let textView = CustomMessageTextView()
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.backgroundColor = UIColor.mainGray()
        textView.layer.cornerRadius = 6
        textView.layer.masksToBounds = true
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.rgb(red: 220, green: 220, blue: 220).cgColor
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    func textViewDidChange(_ textView: UITextView) {
        guard let comment = messageTextView.text else { return }
        messageDelegate?.didChangeTextField(for: comment)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.photoButtonLeftAnchor?.constant = -35
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.photoButtonLeftAnchor?.constant = 10
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    lazy var messageSendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "send_unableicon")?.resize(size: CGSize(width: 25, height: 25))?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleCommentButton), for: .touchUpInside)
        return button
    }()
    
    lazy var photoButton: UIButton = {
       let button = UIButton(type: .system)
        button.setImage(UIImage(named: "camera_icon")?.resize(size: CGSize(width: 30, height: 30))?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePhotoButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handlePhotoButton() {
        messageDelegate?.didTapPhotoButton()
    }
    
    @objc func handleCommentButton() {
        let message = messageTextView.text ?? ""
        messageSendButton.isEnabled = false
        messageDelegate?.didTapSentButton(for: message)
    }
    
    let lineSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    
    var photoButtonLeftAnchor: NSLayoutConstraint?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        
        addSubview(messageSendButton)
        messageSendButton.anchor(top: nil, bottom: nil, left: nil, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: -8, width: 40, height: 40)
        messageSendButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(photoButton)
        photoButtonLeftAnchor = photoButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10)
        [
            photoButtonLeftAnchor,
            photoButton.widthAnchor.constraint(equalToConstant: 35),
            photoButton.heightAnchor.constraint(equalToConstant: 35),
            photoButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            ].forEach{ $0?.isActive = true }
        
        addSubview(messageTextView)
        messageTextView.anchor(top: topAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, left: photoButton.rightAnchor, right: messageSendButton.leftAnchor, paddingTop: 8, paddingBottom: -8, paddingLeft: 5, paddingRight: -8, width: 0, height: 0)
        
        addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: topAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
