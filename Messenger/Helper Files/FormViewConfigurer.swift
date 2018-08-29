//
//  FormViewConfigurer.swift
//  Messenger
//
//  Created by Melinda Griswold on 8/27/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit

class FormViewConfigurer {
    
    func setupLabels(for type: FormViewType) -> [(String, TextFieldType)] {
        switch type {
        case .login, .signup:
            return [("Phone number or email", .insecure) , ("Password", .secure)]
        case .forgotPassword:
            return [("New password", .secure), ("Confirm new password", .secure)]
        }
    }
    
    func getSubmitButtonTitle(for type: FormViewType) -> String {
        switch type {
        case .login:
            return "Log In"
        case .signup:
            return "Sign Up"
        case .forgotPassword:
            return "Reset"
        }
    }
}

enum TextFieldType {
    case secure, insecure
}

enum FormViewType: String {
    case login = "Log In", signup = "Sign Up", forgotPassword = "Reset Password"
}
