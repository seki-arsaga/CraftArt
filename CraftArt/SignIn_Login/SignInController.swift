//
//  ViewController.swift
//  CraftArt
//
//  Created by YusuKe on 2018/11/27.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class SignInController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let profileImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("プロフィール画像を選択", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 100
        button.layer.borderColor = UIColor(white: 0, alpha: 0.05).cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleProfileImageButton), for: .touchUpInside)
        return button
    }()
    
    let emailTextField = SignInTextField(placeholderText: "メールアドレス", selector: #selector(handleChangeTextValue), target: self)
    let passwordTextField: SignInTextField = {
       let tf = SignInTextField(placeholderText: "パスワード", selector: #selector(handleChangeTextValue), target: self)
        tf.isSecureTextEntry = true
        return tf
    }()
    let nameTextField = SignInTextField(placeholderText: "名前", selector: #selector(handleChangeTextValue), target: self)
    let nicknameTextFiled = SignInTextField(placeholderText: "ニックネーム", selector: #selector(handleChangeTextValue), target: self)

    let registerButton: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("登録", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 135, green: 156, blue: 188), for: .normal)
        button.backgroundColor = UIColor.rgb(red: 129, green: 175, blue: 249)
        button.isEnabled = false
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleRegisterButton), for: .touchUpInside)
        return button
    }()
    
    let dontRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("登録せずに進む。", for: .normal)
        return button
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributeText = NSMutableAttributedString(string: "既にアカウントをお持ちの場合は", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.black])
        attributeText.append(NSAttributedString(string: "こちら", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.blue]))
        button.setAttributedTitle(attributeText, for: .normal)
        button.addTarget(self, action: #selector(handleAlreadyHaveAccountButton), for: .touchUpInside)
        return button
    }()
    
    @objc func handleAlreadyHaveAccountButton() {
        navigationController?.popViewController(animated: true)
    }
    
    enum LoginError: Error {
        case incompleteForm
        case invalidEmail
        case incorrectPasswordLength
    }
    
    private func signIn() throws {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        if email.isEmpty || password.isEmpty {
            throw LoginError.incompleteForm
        }
        if !email.isValidEmail {
            throw LoginError.invalidEmail
        }
        if password.count < 8 {
            throw LoginError.incorrectPasswordLength
        }
    }
    
    @objc func handleRegisterButton() {
        do {
            try signIn()
            setupRegisterInfo()
        }catch LoginError.incompleteForm {
            Alert.showBasicAlert(title: "未入力の項目があります。", message: "メールアドレス、パスワード、ニックネームを入力して下さい。", on: self)
        }catch LoginError.invalidEmail {
            Alert.showBasicAlert(title: "無効なメールアドレスです。", message: "メールアドレスのフォームが正しいか確認して下さい。", on: self)
        }catch LoginError.incorrectPasswordLength {
            Alert.showBasicAlert(title: "パスワードが短すぎます。", message: "パスワードは最低8文字以上を\n設定して下さい。", on: self)
        }catch {
            Alert.showBasicAlert(title: "Unable To Login", message: "There was an error when attempting to login", on: self)
        }
    }
    
    fileprivate func setupRegisterInfo() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        let name = nameTextField.text ?? ""
        guard let nickname = nicknameTextFiled.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            if let err = err {
                print("Failed to register with email: ", err)
                return
            }
            
            guard let image = self.profileImageButton.imageView?.image else { return }
            guard let uploadImage = image.jpegData(compressionQuality: 0.3) else { return }
            let fileName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_image").child(fileName)
            
            storageRef.putData(uploadImage, metadata: nil, completion: { (metadata, err) in
                if let err = err {
                    print("Failed to putData to storage: ", err)
                    return
                }
                
                storageRef.downloadURL(completion: { (url, err) in
                    if let err = err {
                        print("Failed to fetch url from storage: ", err)
                        return
                    }
                    
                    guard let imageUrl = url?.absoluteString else { return }
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                    let ref = Database.database().reference().child("users").child(uid)
                    
                    let dic = ["email": email, "password": password, "name": name, "nickname": nickname, "imageUrl": imageUrl]
                    ref.setValue(dic, withCompletionBlock: { (err, ref) in
                        if let err = err {
                            print("Failed to setValue to Firebase: ", err)
                            return
                        }
                        print("Successfully to setValue to firebase...")
                        let mainViewController = MainViewController()
                        self.present(mainViewController, animated: true, completion: nil)
                    })
                })
            })
        }
    }
    
    @objc func handleChangeTextValue() {
        let isFormValue = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0 && nicknameTextFiled.text?.count ?? 0 > 0

        if isFormValue {
            registerButton.isEnabled = true
            registerButton.setTitleColor(UIColor.white, for: .normal)
            registerButton.backgroundColor = UIColor.rgb(red: 5, green: 42, blue: 112)
        }else {
            registerButton.isEnabled = false
            registerButton.setTitleColor(UIColor.rgb(red: 135, green: 156, blue: 188), for: .normal)
            registerButton.backgroundColor = UIColor.rgb(red: 129, green: 175, blue: 249)
        }
    }
    
    @objc func handleProfileImageButton() {
        let imagePickerController = UIImagePickerController()
        present(imagePickerController, animated: true, completion: nil)
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            profileImageButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }else if let originalImage = info[.originalImage] as? UIImage {
            profileImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        profileImageButton.imageView?.contentMode = .scaleAspectFill
        profileImageButton.layer.cornerRadius = profileImageButton.frame.width / 2
        profileImageButton.layer.masksToBounds = true
        
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupBackgroundGradientColor() {
        let gradientBackgroundColor = CAGradientLayer.signInBackgroundColor(frame: view.bounds)
        view.layer.insertSublayer(gradientBackgroundColor, at: 0)
    }
    
    fileprivate func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, nameTextField, nicknameTextFiled, registerButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        view.addSubview(stackView)
        stackView.anchor(top: profileImageButton.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingBottom: 0, paddingLeft: 50, paddingRight: -50, width: 0, height: 245)
        
        view.addSubview(dontRegisterButton)
        dontRegisterButton.anchor(top:  stackView.bottomAnchor, bottom: nil, left: nil, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: -20, width: 200, height: 30)
    }
    
    fileprivate func setupProfileImageButton() {
        view.addSubview(profileImageButton)
        profileImageButton.anchor(top: view.topAnchor, bottom: nil, left: nil, right: nil, paddingTop: 80, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 200, height: 200)
        profileImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgroundGradientColor()
        setupProfileImageButton()
        setupStackView()
        setupAlreadyHaveAccountButton()
        setupKeyboardNotification()
    }
    
    private func setupAlreadyHaveAccountButton() {
        view.addSubview(alreadyHaveAccountButton)

        alreadyHaveAccountButton.anchor(top: nil, bottom: view.bottomAnchor, left: nil, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 300, height: 30)
        alreadyHaveAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: Notification) {
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
        let transform = CGAffineTransform(translationX: 0, y: -keyboardFrame!.size.height + 95)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = transform
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func handleKeyboardWillHide() {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

