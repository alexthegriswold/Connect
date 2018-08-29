//
//  LoginViewController.swift
//  Messenger
//
//  Created by Melinda Griswold on 8/27/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: Views
    let formView: FormView = {
        let view = FormView(frame: .zero, type: .login)
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
        title = "Login"
        
        //set views
        formView.forgotPasswordDelegate = self
        formView.formViewDelegate = self
        formView.frame = view.frame
        grayOutView.frame = view.frame
        [formView, grayOutView].forEach { view.addSubview($0) }
        
        //navbar
        //setupNavBar()
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
    
    /*
    //MARK: Helper functions
    func setupNavBar() {
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "  Back", style: .plain, target: nil, action: nil)
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)]
        
        //remove line
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
 */
}

extension LoginViewController: ForgotPasswordViewDelegate {
    func didTapForgotPassword() {
        self.navigationController?.pushViewController(ForgotPasswordViewController(), animated: true)
    }
}

extension LoginViewController: FormViewDelegate {
    func didTapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didTapSubmit() {
        self.view.endEditing(true)
        self.grayOutView.alpha = 0.5
        let loadingViewController = LoadingViewController()
        loadingViewController.delegate = self
        loadingViewController.modalPresentationStyle = .overCurrentContext
        self.present(loadingViewController, animated: false, completion: nil)
    }
}

extension LoginViewController: AlertViewControllerDelegate {
    
    func alertIsDismissing() {
        UIView.animate(withDuration: 0.4) {
            self.grayOutView.alpha = 0.0
        }
    }
    
    func alertDidDismiss() {
        //navigationController?.popViewController(animated: true)
    }
}

extension LoginViewController: LoadingViewControllerDelegate {
    func loadingTimedOut() {
        
        let viewModel = AlertViewModel(title: "Bad Connection", subtitle: "We were unable to sign you in. Please try again later.", buttonTitle: "Ok")
        let viewController = AlertViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.delegate = self
        self.present(viewController, animated: false, completion: nil)
    }
}
