//
//  ForgotPasswordViewController.swift
//  Messenger
//
//  Created by Melinda Griswold on 8/27/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    //MARK: Views
    let formView: FormView = {
        let view = FormView(frame: .zero, type: .forgotPassword)
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
        
        formView.frame = view.frame
        formView.formViewDelegate = self
        
        grayOutView.frame = view.frame
        [formView, grayOutView].forEach { view.addSubview($0) }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let formInput = formView.formInputs.first else { return }
        formInput.textField.becomeFirstResponder()
        
        for formInput in formView.formInputs {
            formInput.textField.text?.removeAll()
        }
        
        formView.setSubmitButton(to: false)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension ForgotPasswordViewController: FormViewDelegate {
    func didTapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didTapSubmit(formEntries: [String]) {
        self.formView.submitButton.startLoading()
        self.view.endEditing(true)
        self.grayOutView.alpha = 0.5
        
        let username = formEntries[0].lowercased()
        let password = formEntries[1]
        
        let firebaseManager = FirebaseManager()
        let stringResponse = NetworkRequestStringResponses()
        firebaseManager.resetPassword(for: username, with: password) { (success, response) in
            self.formView.submitButton.stopLoading()
            let alertString = stringResponse.createResetPasswordStringResponse(for: response)
            let title = success ? "Awesome!" : "Whoops!"
            
            self.view.endEditing(true)
            self.grayOutView.alpha = 0.5
            
            let viewModel = AlertViewModel(title: title, subtitle: alertString, buttonTitle: "Ok")
            let viewController = AlertViewController(viewModel: viewModel)
            viewController.modalPresentationStyle = .overCurrentContext
            viewController.delegate = self
            self.present(viewController, animated: true, completion: nil)
        }
    }
}

extension ForgotPasswordViewController: AlertViewControllerDelegate {
    
    func alertIsDismissing() {
        UIView.animate(withDuration: 0.4) {
            self.grayOutView.alpha = 0.0
        }
    }
    
    func alertDidDismiss() { }
}

extension ForgotPasswordViewController: LoadingViewControllerDelegate {
    func loadingTimedOut() {
        
        let viewModel = AlertViewModel(title: "Bad Connection", subtitle: "We were unable to reset your password. Please try again later.", buttonTitle: "Ok")
        self.view.endEditing(true)
        let viewController = AlertViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .overCurrentContext
        
        viewController.delegate = self
        self.present(viewController, animated: false, completion: nil)
    }
}


