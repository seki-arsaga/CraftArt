//
//  addPhotoViewController.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/03.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class PostViewController: UIViewController {
    
    var myVar = GlobalVar.shared
    
    let entireImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return iv
    }()
    
    let textView: CustomTextView = {
       let tv = CustomTextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        return tv
    }()
    
    lazy var photoImageButton: PostPhotoButton = {
        let button = PostPhotoButton.init(type: .system, image: myVar.postImage ?? UIImage(named: "dessin _drawing")!, target: self, selector: #selector(handlePhotoImageButton))
        return button
    }()
    
    lazy var loadingImageView = LoadingImageView.init(view: view)
    
    @objc func handlePhotoImageButton() {
//        let addPhotoViewController = AddPhotoViewController.init(collectionViewLayout: UICollectionViewFlowLayout())
//        navigationController?.pushViewController(addPhotoViewController, animated: true)
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(handleCancelButton))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ポスト", style: .plain, target: self, action: #selector(handlePostButton))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    @objc func handlePostButton() {
        guard let image = photoImageButton.imageView?.image else { return }
        guard let uploadImage = image.jpegData(compressionQuality: 0.5) else { return }
        
        Alert.postAlert(title: "確認画面", message: "この内容で投稿してよろしいですか？", on: self) { (_) in
            self.view.addSubview(self.loadingImageView)
            self.textView.isEditable = false
            self.view.endEditing(true)
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            
            let filename = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("posts").child(filename)
            storageRef.putData(uploadImage, metadata: nil) { (metadata, err) in
                if let err = err {
                    self.loadingImageView.removeFromSuperview()
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("Failed to uploaded image to storage: ", err)
                    return
                }
                
                storageRef.downloadURL(completion: { (url, err) in
                    if let err = err {
                        print("Failed to uploaded image to storage: ", err)
                        return
                    }
                    guard let imageUrl = url?.absoluteString else { return }
                    self.savePhotoImageWithDB(imageUrl: imageUrl)
                })
                print("Successfully to uploaded image to storage")
            }
        }
    }
    
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
    
    fileprivate func savePhotoImageWithDB(imageUrl: String) {
        guard let captions = textView.text else { return }
        guard let photoImageUrl = photoImageButton.imageView?.image else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let databaseRef = Database.database().reference().child("posts").child(uid)
        let ref = databaseRef.childByAutoId()
        let values = ["imageUrl": imageUrl, "captions": captions, "witdh": photoImageUrl.size.width, "height": photoImageUrl.size.height, "createdDate": Date().timeIntervalSince1970 ] as [String : Any]
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                self.loadingImageView.removeFromSuperview()
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to uploaded image to DB: ", err)
                return
            }
            print("Successfully to uploaded to DB")
            
            NotificationCenter.default.post(name: PostViewController.updateFeedNotificationName, object: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    var textViewBottomAcncorConstant: NSLayoutConstraint?
    fileprivate func setupViews() {
        StatusBar.setStatusBar(view: view)
        view.addSubview(entireImageView)
        view.addSubview(photoImageButton)
        view.addSubview(textView)
        entireImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 250)
        photoImageButton.anchor(top: nil, bottom: nil, left: view.leftAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 20, paddingRight: 0, width: 200, height: 200)
        photoImageButton.centerYAnchor.constraint(equalTo: entireImageView.centerYAnchor).isActive = true
        textView.anchor(top: entireImageView.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 5, paddingRight: 0, width: 0, height: 0)
        textViewBottomAcncorConstant = textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        textViewBottomAcncorConstant?.isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupNavBar()
        setupViews()
        setupKeyboardNotification()
    }
    
    fileprivate func resetPhotoImageButton() {
        photoImageButton.setImage(myVar.postImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        photoImageButton.imageView?.contentMode = .scaleAspectFill
        photoImageButton.imageView?.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetPhotoImageButton()
    }
    
    func setupKeyboardNotification() {
        NotificationCenter.keyboardWillShow(selector: #selector(handleKeyboardWillShow), observer: self)
        NotificationCenter.keyboardWillHide(selector: #selector(handleKeyboardWillHide), observer: self)
    }
    
    @objc func handleKeyboardWillShow(notification: Notification) {
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.textViewBottomAcncorConstant?.constant = -CGFloat(keyboardFrame!.height)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func handleKeyboardWillHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.textViewBottomAcncorConstant?.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func hideStatusBar() {
        UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.statusBar
    }
    
}
