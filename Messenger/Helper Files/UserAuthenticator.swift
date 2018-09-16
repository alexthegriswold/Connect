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

import Firebase
import FirebaseFirestore

class UserAuthenticator {
    
    let realm = try! Realm()

    
    func authenticate(username: String) -> Bool {
        
        let docRef = global.db.collection("users").document(username)
        
        docRef.getDocument { (document, err) in
            if let document = document, document.exists {
                print("exists")
            } else {
                print("does not exist")
            }
        }
        
        return realm.objects(User.self).filter("username = %@", username).first == nil ? false : true
    }
    
    func authenticate(password: String, for username: String) -> (Bool, AuthenticationResponse, User?) {
        
        let userExists = authenticate(username: username)
        if !userExists { return (false, .invalidUser, nil) }
        
        let userObject = realm.objects(User.self).filter("password = %@ AND username = %@", password, username).first
        
        
        let docRef = global.db.collection("users").document(username)
        docRef.getDocument { (document, err) in
            if let error = err {
                print("Some error happened")
            } else {
                if let document = document {
                    guard let data = document.data() else { return }
                    guard let storedPassword = data["password"] as? String else { return }
                    
                    print("Valid password: ", password == storedPassword)
                }
            }
        }
        
        let userIsSignedInRef = global.db.collection("signedInUsers").document(username)
        
        userIsSignedInRef.setData(["signedIn": true]) { (error) in
            if let error = error {
                print("error happened")
            }
        }
        
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
        let docRef = global.db.collection("users").document(username)
        docRef.setData(["username": username, "password": password]) { (error) in
            if let error = error {
                print("unable to reset password")
            }
        }
        
        if let user = realm.objects(User.self).filter("username = %@", username).first {
            
            try! realm.write {
                user.password = password
            }
            
            return (true, .success)
        } else {
            return ( false, .invalidUser)
        }
    }
    
    func createUser(username: String, password: String) -> (Bool, AuthenticationResponse, User?) {
        
        let collectionRef = global.db.collection("users")
        
        let emailValid = validateEmail(email: username)
        let phoneNumberValid = validatePhone(phone: username)
        
        if !emailValid && !phoneNumberValid { return (false, .invalidEmailOrPhone, nil)}
        
        let userExists = authenticate(username: username)
        if userExists {
            return (false, .userExists, nil)
        } else {
            
            collectionRef.document(username).setData([
                "username": username,
                "password": password
            ]) { (error) in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("Success")
                }
            }
            
            let userIsSignedInRef = global.db.collection("signedInUsers").document(username)
            
            userIsSignedInRef.setData(["signedIn": true]) { (error) in
                if let error = error {
                    print("error happened")
                }
            }
            
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
    
    func validateEmail(email: String) -> Bool {
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }
    
    func validatePhone(phone: String) -> Bool {
        
        if !(10...11).contains(phone.count) { return false }
        return Int(phone) == nil ? false : true
    }
    
    func createLoginStringResponse(for response: AuthenticationResponse) -> String {
        switch response {
        case .invalidPassword, .validUserButInvalidPassword:
            return "That password isn't right! Please try again."
        case .invalidUser:
            return "This username doesn't exist. Try signing up!"
        case .success:
            return "Yay! We're signing you in."
        case .networkError:
            return "We were unable to log you in because of a network error."
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
        case .networkError:
            return "We were unable to log you in because of a network error."
        default:
            return ""
        }
    }
    
    func createSignUpStringResponse(for response: AuthenticationResponse) -> String {
        switch response {
        case .userExists:
            return "That username exists! Please pick another one."
        case .invalidEmailOrPhone:
            return "That won't work! Please use a valid US phone number or email."
        case .networkError:
            return "We were unable to log you in because of a network error."
        default:
            return ""
        }
    }
}
