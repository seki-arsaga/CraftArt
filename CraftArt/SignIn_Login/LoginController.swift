//
//  LoginController.swift
//  CraftArt
//
//  Created by YusuKe on 2018/11/29.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FBSDKLoginKit
import Lottie

class LoginController: UIViewController {
    
    let emailTextField = SignInTextField(placeholderText: "メールアドレス", selector: #selector(handleChangeTextValue), target: self)
    let passwordTextField = SignInTextField(placeholderText: "パスワード", selector: #selector(handleChangeTextValue), target: self)
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ログイン", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 135, green: 156, blue: 188), for: .normal)
        button.backgroundColor = UIColor.rgb(red: 129, green: 175, blue: 249)
        button.isEnabled = false
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLoginButton), for: .touchUpInside)
        return button
    }()
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributeText = NSMutableAttributedString(string: "アカウントをお持ちでない場合は", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.black])
        attributeText.append(NSAttributedString(string: "こちら", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.blue]))
        button.setAttributedTitle(attributeText, for: .normal)
        button.addTarget(self, action: #selector(handleDontHaveAccountButton), for: .touchUpInside)
        return button
    }()
    
    let loginWithFBButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login with Facebook", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.rgb(red: 59, green: 89, blue: 152)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLoginWithFBButton), for: .touchUpInside)
        return button
    }()
    
    lazy var loadingImageView = LoadingImageView.init(view: view)
    
    @objc func handleLoginWithFBButton() {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, err) in
            if let err = err {
                print("Custom FB login failed:", err)
                return
            }
            self.showEmailAdress()
        }
    }
    
    fileprivate func showEmailAdress() {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        Auth.auth().signInAndRetrieveData(with: credentials) { (result, err) in
            if let err = err {
                print("FB login failed:", err)
                return
            }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let email = result?.user.email ?? ""
            let username = result?.user.displayName ?? ""
            let imageUrl = result?.user.photoURL?.absoluteString ?? ""
            
            let fbRef = Database.database().reference().child("users").child(uid)
            let values = ["email": email, "password": "", "username": username, "nickname": username, "imageUrl": imageUrl] as [String : Any]
            fbRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if let err = err {
                    print("Failed to updated fb user info: ", err)
                    return
                }
                print("Successfully to updated fb user info")
                let mainController = MainController()
                self.present(mainController, animated: true, completion: nil)
            })
        }
    }
    
    @objc func handleDontHaveAccountButton() {
        let signInController = SignInController()
        navigationController?.pushViewController(signInController, animated: true)
    }
    
    @objc func handleChangeTextValue() {
        let isFormValue = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValue {
            loginButton.isEnabled = true
            loginButton.setTitleColor(UIColor.white, for: .normal)
            loginButton.backgroundColor = UIColor.rgb(red: 5, green: 42, blue: 112)
        }else {
            loginButton.isEnabled = false
            loginButton.setTitleColor(UIColor.rgb(red: 135, green: 156, blue: 188), for: .normal)
            loginButton.backgroundColor = UIColor.rgb(red: 129, green: 175, blue: 249)
        }
    }
    
    @objc func handleLoginButton() {
        view.addSubview(loadingImageView)
        view.endEditing(true)
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("Failed to signIn with email: ", err)
                self.loadingImageView.removeFromSuperview()
                Alert.showBasicAlert(title: "ログイン失敗。", message: "メールアドレス、もしくはパスワードが間違っています。", on: self)
                return
            }
            
            let mainController = MainController()
            self.present(mainController, animated: true, completion: nil)
            
            print("Success to login")
        }
    }
    
    fileprivate func setupStackViewAndOtherViews() {
        passwordTextField.isSecureTextEntry = true
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        view.addSubview(stackView)
        view.addSubview(loginWithFBButton)
        view.addSubview(dontHaveAccountButton)
        stackView.anchor(top: view.topAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 200, paddingBottom: 0, paddingLeft: 50, paddingRight: -50, width: 0, height: 145)
        loginWithFBButton.anchor(top: stackView.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingBottom: 0, paddingLeft: 50, paddingRight: -50, width: 0, height: 50)
        dontHaveAccountButton.anchor(top: nil, bottom: view.bottomAnchor, left: nil, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 300, height: 30)
        dontHaveAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        
        setupStackViewAndOtherViews()
        setupKeyboardNotification()
    }
    
    func setupKeyboardNotification() {
        NotificationCenter.keyboardWillShow(selector: #selector(handleKeyboardWillShow), observer: self)
        NotificationCenter.keyboardWillHide(selector: #selector(handleKeyboardWillHide), observer: self)
    }
    
    @objc func handleKeyboardWillShow(notification: Notification) {
        let transform = CGAffineTransform(translationX: 0, y: -50)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
