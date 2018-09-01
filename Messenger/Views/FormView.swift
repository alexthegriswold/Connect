//
//  FormView.swift
//  Messenger
//
//  Created by Alexander Griswold on 8/26/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit

class FormView: UIView {
    
    weak var forgotPasswordDelegate: ForgotPasswordViewDelegate? = nil
    weak var formViewDelegate: FormViewDelegate? = nil

    var backButton = RoundBackButton(frame: .zero, width: 31.5)
    
    
    
    var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        label.text = "Login"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var formInputs =  [FormInputItem]()
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.isEnabled = false
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let configurer = FormViewConfigurer()
    let type: FormViewType
    
    init(frame: CGRect, type: FormViewType) {
        
        self.type = type
        super.init(frame: .zero)
        
        //appearance
        backgroundColor = .white
        
        title.text = type.rawValue
        
        //configure formFields
        let inputTitles = configurer.setupLabels(for: type)
        setupFormFields(attributes: inputTitles)
        
        //configure submitButton
        let submitButtonTitle = configurer.getSubmitButtonTitle(for: type)
        submitButton.setTitle(submitButtonTitle, for: .normal)
        
        //add views
        [submitButton, backButton, title].forEach { addSubview($0) }
        
        formInputs.forEach {
            addSubview($0)
            $0.delegate = self
            $0.resignFirstResponder()
        }
        if type == .login { addForgotPassword() }
        
        backButton.addTarget(self, action: #selector(tappedBack), for: .touchUpInside)
        submitButton.addTarget(self, action: #selector(tappedSubmit), for: .touchUpInside)
        
        //auto layout
        setupAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helper functions
    func setupFormFields(attributes: [(String, TextFieldType)]) {
        var array = [FormInputItem]()
        
        for attribute in attributes {
            let (title, type) = attribute
            
            let formInputItem = FormInputItem(frame: .zero, itemTitle: title)
            formInputItem.textField.isSecureTextEntry = (type == .secure)
            formInputItem.translatesAutoresizingMaskIntoConstraints = false
            
            if attributes.last! == attribute {
                formInputItem.textField.returnKeyType = .done
            }
            array.append(formInputItem)
        }
        
        formInputs = array
    }
    
    func addForgotPassword() {
        
        let forgotPassword = UIButton()
        forgotPassword.setTitle("Forgot password?", for: .normal)
        forgotPassword.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        forgotPassword.setTitleColor(UIColor(red:0.39, green:0.52, blue:0.61, alpha:1.0), for: .normal)
        forgotPassword.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(forgotPassword)
        
        forgotPassword.widthAnchor.constraint(equalToConstant: 200).isActive = true
        forgotPassword.heightAnchor.constraint(equalToConstant: 20).isActive = true
        forgotPassword.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 10).isActive = true
        forgotPassword.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        forgotPassword.addTarget(self, action: #selector(tappedForgotPassword), for: .touchUpInside)
    }
    
    func setSubmitButton(to active: Bool) {
        if active {
            submitButton.backgroundColor = UIColor(red:0.26, green:0.64, blue:0.96, alpha:1.0)
            submitButton.isEnabled = true
        } else {
            submitButton.backgroundColor = UIColor(red:0.69, green:0.75, blue:0.77, alpha:1.0)
            submitButton.isEnabled = false
        }
    }
    
    func checkIfTextFieldsHaveText() {
        for formInput in formInputs {
            if formInput.textField.text?.count == 0 {
                setSubmitButton(to: false)
                return
            }
        }
        
        setSubmitButton(to: true)
    }
    
    //MARK: Auto Layout
    func setupAutoLayout() {
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                backButton.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
                title.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
            default:
                backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
                title.centerYAnchor.constraint(equalTo: backButton.centerYAnchor, constant: 0).isActive = true
            }
        }
        
        //align them if not iPhone x
        backButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 31.5).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 31.5).isActive = true
        
        title.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        title.widthAnchor.constraint(equalToConstant: 200).isActive = true
        title.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        for (index, formInput) in formInputs.enumerated() {
            
            formInput.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
            formInput.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
            
            let yAnchor = index == 0 ? title.bottomAnchor : formInputs[index - 1].bottomAnchor
            formInput.topAnchor.constraint(equalTo: yAnchor, constant: 20).isActive = true
        }
        
        guard let lastFormInput = formInputs.last else { return }
        submitButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        submitButton.topAnchor.constraint(equalTo: lastFormInput.bottomAnchor, constant: 20).isActive = true
        submitButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    //MARK: Action targets
    @objc func tappedForgotPassword() {
        forgotPasswordDelegate?.didTapForgotPassword()
    }
    
    
    //MARK: Navigation
    @objc func tappedBack() {
        formViewDelegate?.didTapBack()
    }
    
    @objc func tappedSubmit() {
        if submitButton.isEnabled {
            
            var formEntries = [String]()
            
            for formInput in formInputs {
            
                guard let textInput = formInput.textField.text else { return }
                formEntries.append(textInput)
            }
            formViewDelegate?.didTapSubmit(formEntries: formEntries)
        }
        
    }
}

protocol ForgotPasswordViewDelegate: class {
    func didTapForgotPassword()
}

protocol FormViewDelegate: class {
    func didTapBack()
    func didTapSubmit(formEntries: [String])
}

extension FormView: FormInputItemDelegate {
    func primaryActionTriggered(returnType: UIReturnKeyType) {
        //set next form item to active
        for (index, formInput) in formInputs.enumerated() {
            
            if formInputs.last == formInput { continue }
            
            if returnType == .done {
                tappedSubmit()
                return
            }
            
            formInputs[index].textField.resignFirstResponder()
            formInputs[index + 1].textField.becomeFirstResponder()
            
            }
    }

    func editingChanged() {
        checkIfTextFieldsHaveText()
    }
}

