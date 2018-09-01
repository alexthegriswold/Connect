//
//  WelcomeScreenView.swift
//  Messenger
//
//  Created by Alexander Griswold on 8/25/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class WelcomeView: UIView {
    
    weak var delegate: WelcomeViewDelegate? = nil
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.15, green:0.22, blue:0.27, alpha:1.0)
        view.alpha = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Connect"
        label.font = UIFont.systemFont(ofSize: 45, weight: UIFont.Weight.bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "A chat app"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)
        label.textColor = UIColor(red:0.81, green:0.85, blue:0.86, alpha:1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let signUp: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        button.backgroundColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let login: UIButton = {
        let button = UIButton()
        button.setTitle("I already have an account", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        button.setTitleColor(UIColor(red:0.81, green:0.85, blue:0.86, alpha:1.0), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var signupYConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        //add subviews
        [backgroundView, titleLabel, subtitleLabel, signUp, login].forEach { addSubview($0) }
        
        //auto layout
        setupAutoLayout()
        signupYConstraint = NSLayoutConstraint(item: signUp, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0)
        signupYConstraint?.isActive = true
        
        //add targets
        signUp.addTarget(self, action: #selector(tappedSignUp), for: .touchUpInside)
        login.addTarget(self, action: #selector(tappedLogin), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Auto layout
    func setupAutoLayout() {
        
        backgroundView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true 
        
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -150).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        subtitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        subtitleLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        subtitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        signUp.widthAnchor.constraint(equalToConstant: 200).isActive = true
        signUp.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signUp.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        let constraint = NSLayoutConstraint()
        constraint.constant = 150
    
        
        login.widthAnchor.constraint(equalToConstant: 200).isActive = true
        login.heightAnchor.constraint(equalToConstant: 30).isActive = true
        login.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        login.topAnchor.constraint(equalTo: signUp.bottomAnchor, constant: 10).isActive = true
    }
    
    //MARK: Action targets
    @objc func tappedSignUp() {
        
        self.delegate?.didTapSignUp()
        
//       signupYConstraint?.constant = 0
//
//        UIView.animate(withDuration: 0.175, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
//
//            self.signUp.titleLabel?.alpha = 0.0
//            self.login.alpha = 0.0
//            self.layoutIfNeeded()
//
//        }, completion: { _ in
//
//            self.delegate?.didTapSignUp()
//        })
    }
    
    @objc func tappedLogin() {
        delegate?.didTapLogin()
    }
}

protocol WelcomeViewDelegate: class {
    func didTapSignUp()
    func didTapLogin()
}
