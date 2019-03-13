//
//  Firebase-Ext.swift
//  CraftArt
//
//  Created by YusuKe on 2018/12/08.
//  Copyright © 2018年 YusuKe. All rights reserved.
//

import UIKit
import Firebase

extension Database {
    
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDic = snapshot.value as? [String: Any] else { return }
            let user = User.init(uid: uid, dictionary: userDic)
            
            completion(user)
            
        }) { (err) in
            print("Failed to fetch user for posts: ", err)
        }
    }
    
    
    static func fetchUserInfoFromFB(items: [User], collectionView: UICollectionView) {
        var items = items
        
        let dataRef = Database.database().reference().child("users")
        dataRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            dictionary.forEach({ (key, value) in
                
                if key == Auth.auth().currentUser?.uid {
                    return
                }
                
                guard let userDictionary = value as? [String: Any] else { return }
                let user = User.init(uid: key, dictionary: userDictionary)
                items.append(user)
            })
            
            items.sort(by: { (u1, u2) -> Bool in
                return u1.nickname.compare(u2.nickname) == .orderedAscending
            })
            
            collectionView.reloadData()
            
        }) { (err) in
            print("Failed to fetch user info: ", err)
        }
    }
    
}



let imageCaches = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        self.image = nil
        if let cachedImage = imageCaches.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async(execute: {
                if let downloadedImage = UIImage(data: data!) {
                    imageCaches.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.image = downloadedImage
                }
            })
        }).resume()
    }
}
