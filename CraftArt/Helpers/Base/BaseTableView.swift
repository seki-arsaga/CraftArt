//
//  BaseTableView.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/15.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit

class BaseTableView<T: BaseTableViewCell<U>, U>: UITableViewController {
    
    let cellId = "cellId"
    var items = [U]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    fileprivate func setupTableView() {
        tableView.register(T.self, forCellReuseIdentifier: cellId)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BaseTableViewCell<U>
        cell.item = items[indexPath.item]
        
        return cell
    }
    
}
