//
//  NetworkRequestStringResponses.swift
//  Messenger
//
//  Created by Melinda Griswold on 9/16/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import Foundation

enum AuthenticationResponse {
    case invalidUser, invalidPassword, validUserButInvalidPassword, success
    case userExists
    case invalidEmailOrPhone
    case networkError
}

class NetworkRequestStringResponses {
    
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
