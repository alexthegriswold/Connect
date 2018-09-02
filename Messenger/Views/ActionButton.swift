//
//  ActionButton.swift
//  Messenger
//
//  Created by Melinda Griswold on 8/31/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit

class ActionButton: UIView {
    
    //MARK: Delegate
    weak var delegate: ActionButtonDelegate? = nil
    
    //MARK: Views
    var plusButton: RoundBackButton = {
        let button = RoundBackButton(frame: .zero, width: 40, color: UIColor(red:0.26, green:0.64, blue:0.96, alpha:1.0))
        button.transform = CGAffineTransform(rotationAngle: -2.35619)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let imageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 14
        button.alpha = 1.0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        button.setImage(#imageLiteral(resourceName: "camera"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let videoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 14
        button.alpha = 1.0
        
        button.setImage(#imageLiteral(resourceName: "videoCamera"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let specialButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 14
        button.alpha = 1.0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        button.setTitle("?", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
     
        return button
    }()
    
    //variables
    let plusRotate = CGAffineTransform(rotationAngle: -2.35619).inverted()
    var expanded = false
    
    //MARK: Override functions
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = true
        layer.cornerRadius = 20
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(red:0.13, green:0.53, blue:0.90, alpha:1.0)
        [imageButton, videoButton, specialButton, plusButton].forEach { addSubview($0) }

        setupAutoLayout()
        
        plusButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        imageButton.addTarget(self, action: #selector(tappedImageButton), for: .touchUpInside)
        videoButton.addTarget(self, action: #selector(tappedVideoButton), for: .touchUpInside)
        specialButton.addTarget(self, action: #selector(tappedSpecialButton), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAutoLayout() {
        [
            plusButton.widthAnchor.constraint(equalToConstant: 40),
            plusButton.heightAnchor.constraint(equalToConstant: 40),
            plusButton.topAnchor.constraint(equalTo: self.topAnchor),
            plusButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0)
            ].forEach { $0.isActive = true }
        
        [
            imageButton.widthAnchor.constraint(equalToConstant: 50),
            imageButton.heightAnchor.constraint(equalToConstant: 28),
            imageButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            imageButton.centerYAnchor.constraint(equalTo: centerYAnchor)
            ].forEach { $0.isActive = true }

        [
            videoButton.widthAnchor.constraint(equalToConstant: 50),
            videoButton.heightAnchor.constraint(equalToConstant: 28),
            videoButton.leftAnchor.constraint(equalTo: imageButton.rightAnchor, constant: 15),
            videoButton.centerYAnchor.constraint(equalTo: centerYAnchor)
            ].forEach { $0.isActive = true }

        [
            specialButton.widthAnchor.constraint(equalToConstant: 50),
            specialButton.heightAnchor.constraint(equalToConstant: 28),
            specialButton.leftAnchor.constraint(equalTo: videoButton.rightAnchor, constant: 15),
            specialButton.centerYAnchor.constraint(equalTo: centerYAnchor)
            ].forEach { $0.isActive = true }
    }
    
    //MARK: Action listeners
    @objc func didTap() {
    
        if expanded == false {
            UIView.animate(withDuration: 0.20) {
                //going out
                let rotate = CGAffineTransform(rotationAngle: 0.0)
                let scaleWithRotate = rotate.concatenating(CGAffineTransform(scaleX: 0.7, y: 0.7))
                self.plusButton.transform = scaleWithRotate
                [self.imageButton, self.videoButton, self.specialButton].forEach { $0.alpha = 1.0 }
            }
        } else {
            UIView.animate(withDuration: 0.20) {
                //coming in
                let rotate = CGAffineTransform(rotationAngle: -2.35619)
                let scaleWithRotate = rotate.concatenating(CGAffineTransform(scaleX: 1.0, y: 1.0))
                self.plusButton.transform = scaleWithRotate
                [self.imageButton, self.videoButton, self.specialButton].forEach { $0.alpha = 0.0 }
            }
        }
        
        expanded = !expanded
    }
    
    @objc func tappedImageButton() {
        delegate?.tappedImageButton()
    }
    
    @objc func tappedVideoButton() {
        delegate?.tappedVideoButton()
    }
    
    @objc func tappedSpecialButton() {
        delegate?.tappedSpecialButton()
    }
}

protocol ActionButtonDelegate: class {
    func tappedImageButton()
    func tappedVideoButton()
    func tappedSpecialButton()
}
