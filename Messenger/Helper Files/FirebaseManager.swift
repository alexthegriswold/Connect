//
//  FirebaseManager.swift
//  Messenger
//
//  Created by Melinda Griswold on 9/15/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

enum NetworkError {
    case error
}

class FirebaseManager {
    
    //check username
    func checkIfValid(username: String, completion: @escaping (Bool, NetworkError?) -> Void) {
        
        let docRef = global.db.collection("users").document(username)
        
        docRef.getDocument { (doc, err) in
            
            if err != nil {
                completion(false, .error)
                return
            }
            
            guard let document = doc else {
                completion(false, nil)
                return
            }
            
            completion(document.exists, nil)
        }
    }
    
    //check password
    func checkIfValid(password: String, for username: String, completion: @escaping (Bool, NetworkError?) -> Void) {
        
        let collection = global.db.collection("users")
            .whereField("username", isEqualTo: username)
            .whereField("password", isEqualTo: password)
        
        collection.getDocuments { (docs, err) in
            guard err == nil else {
                completion(false, .error)
                return
            }
            
            let docExists = docs?.documents.first != nil
            completion(docExists, nil)
        }
    }
    
    //log in
    func logIn(password: String, for username: String, completion: @escaping (Bool, AuthenticationResponse, String?) -> Void) {

        //check if user exists
        checkIfValid(username: username) { (userExists, err) in
    
            guard err == nil else {
                completion(false, .networkError, nil)
                return
            }
            if !userExists { completion(false, .invalidUser, nil) }
            
            self.checkIfValid(password: password, for: username, completion: { (valid, err) in
                guard err == nil else {
                    completion(false, .networkError, nil)
                    return
                }
                
                if valid {
                    //if valid user attempt to log in
                    self.setSignedIn(for: username) { (error) in
                        if error == nil {
                            completion(true, .success, username)
                        } else {
                            completion(false, .networkError, nil)
                        }
                    }
                } else {
                    completion(false, .invalidPassword, nil)
                }
            })
        }
    }
    
    //sign in
    func setSignedIn(for username: String, _ completion: @escaping (NetworkError?) -> Void) {
        let userIsSignedInRef = global.db.collection("signedInUsers").document(username)
        
        userIsSignedInRef.setData(["signedIn": true]) { (err) in
        
            if err != nil {
                completion(.error)
            } else {
                completion(nil)
            }
        }
    }
    
    //reset password
    func resetPassword(for username: String, with password: String, _ completion:  @escaping (Bool, AuthenticationResponse) -> Void) {
        
        checkIfValid(username: username) { (isUser, err) in
            if err != nil {
                completion(false, .networkError)
                return
            }
            
            let docRef = global.db.collection("users").document(username)
            docRef.setData([
                "username": username,
                "password": password
            ]) { (err) in
                if err != nil {
                    completion(false, .networkError)
                } else {
                    completion(true, .success)
                }
            }
        }
    }
    
    func createUser(username: String, password: String, _ completion:  @escaping (Bool, AuthenticationResponse, String?) -> Void) {
        
        let collectionRef = global.db.collection("users")
        
        let emailValid = validateEmail(email: username)
        let phoneNumberValid = validatePhone(phone: username)
        
        if !emailValid && !phoneNumberValid {
            completion(false, .invalidEmailOrPhone, nil)
            return
        }
        
        checkIfValid(username: username) { (isUser, err) in
            if err != nil {
                completion(false, .networkError, nil)
                return
            }
            
            if isUser {
                completion(false, .userExists, nil)
                return
            }
            
            collectionRef.document(username).setData([
                "username": username,
                "password": password
            ]) { (error) in
                if error != nil {
                    completion(false, .networkError, nil)
                    return
                }
                
                //if valid user attempt to log in
                self.setSignedIn(for: username) { (error) in
                    if error == nil {
                        completion(true, .success, username)
                    } else {
                        completion(false, .networkError, nil)
                    }
                }
            }
        }
    }
    
    //fix this
//    func checkIfLoggedIn() -> User? {
//        return realm.objects(User.self).filter("signedIn == true").first
//    }
    
    func signOut(username: String, _ completion: @escaping (Bool, NetworkError?) -> Void) {
        let docRef = global.db.collection("signedInUsers").document(username)
        
        docRef.updateData(["signedIn": true]) { (err) in
            if err != nil {
                completion(false, .error)
            } else {
                completion(true, nil)
            }
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
}
