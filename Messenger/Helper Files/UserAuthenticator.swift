//
//  AuthenicateUser.swift
//  Messenger
//
//  Created by Melinda Griswold on 9/1/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

enum AuthenticationResponse {
    case invalidUser, invalidPassword, validUserButInvalidPassword, success
    case userExists
}

class UserAuthenticator {
    
    let realm = try! Realm()
    
    func authenticate(username: String) -> Bool {
        return realm.objects(User.self).filter("username = %@", username).first == nil ? false : true
    }
    
    func authenticate(password: String, for username: String) -> (Bool, AuthenticationResponse, User?) {
        
        let userExists = authenticate(username: username)
        if !userExists { return (false, .invalidUser, nil) }
        let userObject = realm.objects(User.self).filter("password = %@ AND username = %@", password, username).first
        
        if let userObject = userObject {
            try! realm.write {
                userObject.signedIn = true
            }
            return (true, .success, userObject)
        } else {
            return (false, .invalidPassword, nil)
        }
    }
    
    func resetPassword(for username: String, with password: String) -> (Bool, AuthenticationResponse){
        if var user = realm.objects(User.self).filter("username = %@", username).first {
            
            try! realm.write {
                user.password = password
            }
 
            return (true, .success)
        } else {
            return ( false, .invalidUser)
        }
    }
    
    func createUser(username: String, password: String) -> (Bool, AuthenticationResponse, User?) {
        let userExists = authenticate(username: username)
        if userExists {
            return (false, .userExists, nil)
        } else {
            
            let user = User()
            user.password = password
            user.username = username
            user.signedIn = true
            
            try! realm.write {
                realm.add(user)
            }
            
            return (true, .success, user)
        }
    }
    
    func checkIfLoggedIn() -> User? {
        return realm.objects(User.self).filter("signedIn == true").first
    }
    
    func signOut(user: User) {
        try! realm.write {
            user.signedIn = false
        }
    }
    
    func createLoginStringResponse(for response: AuthenticationResponse) -> String {
        switch response {
        case .invalidPassword, .validUserButInvalidPassword:
            return "That password isn't right! Please try again."
        case .invalidUser:
            return "This username doesn't exist. Try signing up!"
        case .success:
            return "Yay! We're signing you in."
        default:
            return ""
        }
    }
    
    func createResetPasswordStringResponse(for response: AuthenticationResponse) -> String {
        switch response {
        case .invalidUser:
            return "This username doesn't exist! Please enter your correct username."
        case .success:
            return "Awesome! Now go log in."
        default:
            return ""
        }
    }
    
    func createSignUpStringResponse(for response: AuthenticationResponse) -> String {
        switch response {
        case .userExists:
            return "That username exists! Please pick another one."
        default:
            return ""
        }
    }
    
    
    
}
