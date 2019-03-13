//
//  MessageLogController.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/13.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit
import Firebase

class MessageLogController: BaseTableView<MessageLogCell, Message> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        fetchMessageInfoFromDB()
    }
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = .white
    }
    
    
    func fetchMessageInfoFromDB() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("messages").child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let userId = snapshot.key
            let messageRef = Database.database().reference().child("messages").child("user-messages").child(uid).child(userId)
            messageRef.observe(.childAdded, with: { (snapshot) in
                
                let messageId = snapshot.key
                self.fetchMessageWithMessgaeId(userId: userId, messageId: messageId)
                
            }, withCancel: nil)
            return
        }, withCancel: nil)
        
    }
    
    var messagesDic = [String: Message]()
    fileprivate func fetchMessageWithMessgaeId(userId: String, messageId: String) {
        let messageRef = Database.database().reference().child("messages").child("all-message").child(messageId)
        messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dic = snapshot.value as? [String: Any] else { return }
            var message = Message(dictionary: dic)
            
            let userRef = Database.database().reference().child("users").child(userId)
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                let user = User.init(uid: userId, dictionary: dictionary)
                message.user = user
                
                self.items.append(message)
                
                let chatpartnerId = message.toId
                self.messagesDic[chatpartnerId] = message
                
                self.attemptReloadOfTable()
                
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    private func attemptReloadOfTable() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    var timer: Timer?
    @objc func handleReloadTable() {
        self.items = Array(self.messagesDic.values)
        self.items.sort(by: { (message1, message2) -> Bool in
            return message1.creationDate > message2.creationDate
        })
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        let messageController = MessageController.init(collectionViewLayout: layout)
        messageController.user = items[indexPath.item].user
        navigationController?.pushViewController(messageController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
