//
//  WriteTestUserData.swift
//  Messenger
//
//  Created by Melinda Griswold on 9/1/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class UserTestDataGenerator {
    
    let realm = try! Realm()
    
    init() {
        let users = realm.objects(User.self)
        print(users.count)
        if users.count == 0 {
            generateData()
        }
    }
    
    private func generateData() {
        generateUsers()
    }
    
    private func generateUsers() {
        let user1 = User()
        user1.username = "alex@mobilepic.co"
        user1.password = "123456"
        
        let user2 = User()
        user2.username = "9547896903"
        user2.password = "password"
        
        let user3 = User()
        user3.username = "email@google.com"
        user3.password = "letmein"
        
        try! realm.write {
            
            [user1, user2, user3].forEach { realm.add($0) }
        }
    }
    
}
