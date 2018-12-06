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

class LoginController: UIViewController {
    
    let emailTextField = SignInTextField(placeholderText: "メールアドレス", selector: #selector(handleChangeTextValue), target: self)
    let passwordTextField: SignInTextField = {
        let tf = SignInTextField(placeholderText: "パスワード", selector: #selector(handleChangeTextValue), target: self)
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ログイン", for: .normal)
        button.setTitleColor(UIColor.rgb(red: 135, green: 156, blue: 188), for: .normal)
        button.backgroundColor = UIColor.rgb(red: 129, green: 175, blue: 249)
        button.isEnabled = false
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleRegisterButton), for: .touchUpInside)
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
    
    @objc func handleRegisterButton() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("Failed to signIn with email: ", err)
                Alert.showBasicAlert(title: "ログイン失敗。", message: "メールアドレス、もしくはパスワードが間違っています。", on: self)
                return
            }
            
            let mainViewController = MainViewController()
            self.present(mainViewController, animated: true, completion: nil)
            
            print("Success to login")
        }
    }
    
    fileprivate func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        view.addSubview(stackView)
        stackView.anchor(top: view.topAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 250, paddingBottom: 0, paddingLeft: 50, paddingRight: -50, width: 0, height: 145)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationController?.isNavigationBarHidden = true
        
        setupStackView()
        setupDontHaveAccountButton()
    }
    
    private func setupDontHaveAccountButton() {
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil, bottom: view.bottomAnchor, left: nil, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 300, height: 30)
        dontHaveAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
