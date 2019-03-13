//
//  MessageViewController.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/09.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class MessageController: BaseCollectionViewController<MessageCell, Message>, MessageAccesoryViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let headerId = "headerId"
    var user: User?
    var messages = [[Message]]()
    var messageHeader = MessageHeader()
    
    fileprivate func setupCollectionView() {
        navigationItem.title = user!.nickname
        
        tabBarController?.tabBar.isHidden = true
        
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 8, right: 0)
        collectionView.register(MessageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }

    override func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        fecthMessageWithUserInfo()
    }
    
    fileprivate func fecthMessageWithUserInfo() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let userId = user!.uid else { return }
        
        let messageRef = Database.database().reference().child("messages").child("user-messages").child(uid)
        messageRef.child(userId).observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            
            self.fecthMEssageWithMessageId(messageId: messageId, userId: userId)
        }) { (err) in
            print("Feiled to fetch message info:", err)
            return
        }
    }
    
    var dateString: String?
    var reversedArray = [[Message]]()
    fileprivate func fecthMEssageWithMessageId(messageId: String, userId: String) {
        let messageRef = Database.database().reference().child("messages").child("all-message").child(messageId)
        
        let query = messageRef.queryOrderedByKey().queryLimited(toLast: 10)

        query.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dic = snapshot.value as? [String: Any] else { return }
            let message = Message.init(dictionary: dic)
                        
            let secondsfrom1970 = dic["timestamp"] as? Double ?? 0
            let creationDate = Date(timeIntervalSince1970: secondsfrom1970)
            let date = self.dateFormatter.string(from: creationDate)

            if self.dateString != date {
                self.messages.append([message])
                self.dateString = date
            }else {
                let last = self.messages.count - 1
                self.messages[last].append(message)
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                let lastIndex = IndexPath(item: (self.messages.last?.count)! - 1, section: self.messages.count - 1)
                self.collectionView.scrollToItem(at: lastIndex, at: .bottom, animated: true)
            }
        }, withCancel: nil)
    }
    
    let dateFormatter: DateFormatter = {
        let format = DateFormatter()
        format.dateFormat = "MM/dd(EEE)"
        format.locale = Locale(identifier: "ja_JP")
        return format
    }()
    
    var dates = [String]()
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! MessageHeader
        
        let date = self.messages[indexPath.section]
        header.date = date

        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize(width: view.frame.width, height: 45)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages[section].count
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        let message = messages[indexPath.section][indexPath.row]
        if let text = message.text {
            height = estimateFrameForText(text: text).height + 25
        }else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
            height = CGFloat(imageHeight / imageWidth * 200)
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCell
        cell.messageController = self
        
        let message = messages[indexPath.section][indexPath.row]

        cell.item = messages[indexPath.section][indexPath.row]
        setupCell(cell: cell, message: message)
        
        if let text = message.text {
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: text).width + 50
        }else if message.imageUrl != nil {
            cell.bubbleWidthAnchor?.constant = 200
        }
        
        return cell
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    private func setupCell(cell: MessageCell, message: Message) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if message.fromId == uid {
            cell.bubbleView.backgroundColor = UIColor.rgb(red: 73, green: 121, blue: 198)
            cell.textView.textColor = .white
            cell.profileImageView.isHidden = true
            
            cell.bubbleRightAnchor?.isActive = true
            cell.bubbleLeftAnchor?.isActive = false
        }else {
            cell.bubbleView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
            cell.textView.textColor = .black
            cell.profileImageView.isHidden = false
            
            cell.bubbleRightAnchor?.isActive = false
            cell.bubbleLeftAnchor?.isActive = true
        }
        
        if let messageImageUrl = message.imageUrl {
            cell.messageImageView.loadImageUsingCacheWithUrlString(messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = .clear
        }else {
            cell.messageImageView.isHidden = true
        }
    }
    
    lazy var containerView: MessageAccessoryView = {
        let view = MessageAccessoryView()
        view.backgroundColor = .white
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        view.messageDelegate = self
        return view
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func didTapSentButton(for message: String) {
        let properties: [String: Any] = ["text": message]
        sendMessageWithProperties(properties: properties)
    }
    
    func didChangeTextField(for comment: String) {
        let isTextValue = comment.count > 0
        if isTextValue {
            containerView.messageSendButton.setImage(UIImage(named: "send_ableicon")?.resize(size: CGSize(width: 25, height: 25))?.withRenderingMode(.alwaysOriginal), for: .normal)
            containerView.messageSendButton.isEnabled = true
        }else {
            containerView.messageSendButton.setImage(UIImage(named: "send_unableicon")?.resize(size: CGSize(width: 25, height: 25))?.withRenderingMode(.alwaysOriginal), for: .normal)
            containerView.messageSendButton.isEnabled = false
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func didTapPhotoButton() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        imagePickerController.navigationBar.tintColor = .white
        imagePickerController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        
        if let editImage = info[.editedImage] as? UIImage {
            selectedImage = editImage
        }else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        uploadToFirebaseStorageUsingImage(image: selectedImage!)
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func uploadToFirebaseStorageUsingImage(image: UIImage) {
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("message_image").child(fileName)
        
        if let uploadData = image.jpegData(compressionQuality: 0.3) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
                if let err = err {
                    print("Failed to upload image: ", err)
                    return
                }
                
                print("Successfully to upload to Storage:")
                storageRef.downloadURL(completion: { (url, err) in
                    if let err = err {
                        print(err)
                        return
                    }
                    
                    let url = url?.absoluteString ?? ""
                    self.sendMessageWithImageUrl(imageUrl: url, image: image)
                })
            }
        }
    }
    
    private func sendMessageWithImageUrl(imageUrl: String, image: UIImage) {
        let properties: [String: Any] = ["imageUrl": imageUrl, "imageWidth": image.size.width, "imageHeight": image.size.height]
        sendMessageWithProperties(properties: properties)
    }
    
    fileprivate func sendMessageWithProperties(properties: [String: Any]) {
        containerView.messageSendButton.setImage(UIImage(named: "send_unableicon")?.resize(size: CGSize(width: 25, height: 25))?.withRenderingMode(.alwaysOriginal), for: .normal)
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        guard let toId = user!.uid else { return }
        
        let userRef = Database.database().reference().child("users").child(fromId)
        userRef.observe(.value, with: { (snapshot) in
            guard let dic = snapshot.value as? [String: Any] else { return }
            
            let profileImageUrl = dic["imageUrl"] as! String
            let messageRef = Database.database().reference().child("messages")
            let childRef = messageRef.child("all-message").childByAutoId()
            var values = ["profileImageUrl": profileImageUrl, "timestamp": Date().timeIntervalSince1970, "fromId": fromId, "toId": toId] as [String : Any]
            properties.forEach({ values[$0] = $1})
            
            childRef.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to updated message info:", err)
                    return
                }
                let userMessageRef = messageRef.child("user-messages").child(fromId).child(toId)
                let messageId = childRef.key
                userMessageRef.updateChildValues([messageId!: true])
                
                let recipianUserMessageRef = messageRef.child("user-messages").child(toId).child(fromId)
                recipianUserMessageRef.updateChildValues([messageId!: 1])
                print("Successfully to updated message info!")
                self.containerView.endMessage()
            }
        }) { (err) in
        }
    }
    
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    
    func performZoomInForImageView(startingImageView: UIImageView) {
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = .red
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleVerticalSwipe))
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleVerticalSwipe))
        downSwipe.direction = .down
        upSwipe.direction = .up
        zoomingImageView.addGestureRecognizer(downSwipe)
        zoomingImageView.addGestureRecognizer(upSwipe)

        if let keyWindow = UIApplication.shared.keyWindow {
            self.blackBackgroundView = UIView(frame: keyWindow.frame)
            self.blackBackgroundView!.backgroundColor = .black
            self.blackBackgroundView!.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackBackgroundView!.alpha = 1
                self.containerView.alpha = 0
                
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
                
            }, completion: nil)
        }
    }
    
    @objc func handleVerticalSwipe(swipeGesture: UISwipeGestureRecognizer) {
        if swipeGesture.direction == .down || swipeGesture.direction == .up {
            print("swipeGesture: ", swipeGesture)
            if let zoomOutImageView = swipeGesture.view {
                zoomOutImageView.layer.cornerRadius = 10
                zoomOutImageView.layer.masksToBounds = true
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    zoomOutImageView.frame = self.startingFrame!
                    self.blackBackgroundView?.alpha = 0
                    self.containerView.alpha = 1
                    self.view.layoutIfNeeded()
                    
                }) { (completed) in
                    zoomOutImageView.removeFromSuperview()
                    self.startingImageView?.isHidden = false
                }
            }
        }
    }
    
    @objc func handleZoomOut(tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            zoomOutImageView.layer.cornerRadius = 10
            zoomOutImageView.layer.masksToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.containerView.alpha = 1
                self.view.layoutIfNeeded()
                
            }) { (completed) in
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            }
        }
    }
    
}
