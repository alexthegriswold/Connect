//
//  ActionButton.swift
//  Messenger
//
//  Created by Melinda Griswold on 8/31/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit

class ActionButton: UIView {
    
    weak var delegate: ActionButtonDelegate? = nil
    
    let plusButton: RoundBackButton = {
        let button = RoundBackButton(frame: .zero, width: 40)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let stackView: UIStackView = {
       let stackView = UIStackView()
        
        return stackView
    }()
    
    let imageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 14
        button.alpha = 0.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let plusRotate = CGAffineTransform(rotationAngle: 0.785398)
    var plusRotateInverted = CGAffineTransform(rotationAngle: 0.785398).inverted()
    
    var expanded = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        plusButton.transform = plusRotate
        plusRotateInverted = plusRotate.inverted()
        layer.masksToBounds = true
        layer.cornerRadius = 20
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .cyan
        [plusButton, imageButton].forEach { addSubview($0) }
        
        setupAutoLayout()
        
        plusButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        imageButton.addTarget(self, action: #selector(tappedImageButton), for: .touchUpInside)
    }
    
    @objc func didTap() {
        
        if expanded {
            UIView.animate(withDuration: 0.2) {
                self.plusButton.transform = self.plusRotate
                self.plusButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.imageButton.alpha = 0.0
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.plusButton.transform = self.plusRotateInverted
                self.plusButton.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                self.imageButton.alpha = 1.0
            }
        }
        
        expanded = !expanded
    }
    
    @objc func tappedImageButton() {
        delegate?.tappedImageButton()
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
            imageButton.widthAnchor.constraint(equalToConstant: 28),
            imageButton.heightAnchor.constraint(equalToConstant: 28),
            imageButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
            ].forEach { $0.isActive = true }
        
    }
}

protocol ActionButtonDelegate: class {
    func tappedImageButton()
}
