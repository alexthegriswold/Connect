//
//  FormViewController.swift
//  Messenger
//
//  Created by Alexander Griswold on 8/26/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    let authenticator = UserAuthenticator()
    
    //views
    let formView: FormView = {
        let view = FormView(frame: .zero, type: .signup)
        return view
    }()
    
    let grayOutView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.alpha = 0.0
        return view
    }()
    
    //MARK: View Controller override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set attributes
        title = "Sign Up"
        
        //add views
        formView.frame = view.frame
        grayOutView.frame = view.frame
        [formView, grayOutView].forEach { view.addSubview($0) }
        formView.formViewDelegate = self
        
        //configure navbar
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let formInput = formView.formInputs.first else { return }
        formInput.textField.becomeFirstResponder()
        
        for formInput in formView.formInputs {
            formInput.textField.text?.removeAll()
        }
        
        formView.setSubmitButton(to: false)
    }
    
    //hides the status bar from the app
    override var prefersStatusBarHidden: Bool {
        return true
    } 
    
    //helper functions
    func setupNavBar() {
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)]
        
        
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}

extension SignUpViewController: FormViewDelegate {
    func didTapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didTapSubmit(formEntries: [String]) {
        let username = formEntries[0].lowercased()
        let password = formEntries[1]
        
        let (success, response, user) = authenticator.createUser(username: username, password: password)
        
        if success {
            let messengerViewController = MessengerViewController(collectionViewLayout: UICollectionViewFlowLayout(), user: user!)
            let navigationController = UINavigationController(rootViewController: messengerViewController)
            self.present(navigationController, animated: true, completion: nil)
        } else {
            self.view.endEditing(true)
            self.grayOutView.alpha = 0.5
            
            let alertMessage = authenticator.createSignUpStringResponse(for: response)
            let viewModel = AlertViewModel(title: "Whoops!", subtitle: alertMessage, buttonTitle: "Ok")
            let viewController = AlertViewController(viewModel: viewModel)
            viewController.modalPresentationStyle = .overCurrentContext
            viewController.delegate = self
            self.present(viewController, animated: true, completion: nil)
        }
    }
}

extension SignUpViewController: AlertViewControllerDelegate {
    
    func alertIsDismissing() {
        UIView.animate(withDuration: 0.4) {
            self.grayOutView.alpha = 0.0
        }
    }
    
    func alertDidDismiss() {
        //navigationController?.popViewController(animated: true)
    }
}

extension SignUpViewController: LoadingViewControllerDelegate {
    func loadingTimedOut() {
        
        let viewModel = AlertViewModel(title: "Bad Connection", subtitle: "We were unable to sign you up. Please try again later.", buttonTitle: "Ok")
        let viewController = AlertViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.delegate = self
        self.present(viewController, animated: false, completion: nil)
    }
}
