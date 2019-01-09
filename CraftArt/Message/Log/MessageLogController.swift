//
//  MessageLogController.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/13.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

class MessageLogController: UITableViewController {
    
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .blue
        
        return cell
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
