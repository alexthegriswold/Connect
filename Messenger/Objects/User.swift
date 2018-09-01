//
//  User.swift
//  Messenger
//
//  Created by Melinda Griswold on 9/1/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import Realm
import RealmSwift

class User: Object {
    @objc dynamic var signedIn = false
    @objc dynamic var username = ""
    @objc dynamic var password = ""
}
