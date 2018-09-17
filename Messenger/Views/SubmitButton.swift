//
//  SubmitButton.swift
//  Messenger
//
//  Created by Melinda Griswold on 9/17/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit

class SubmitButton: UIButton {

    var infinityShape: InfinityShape?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .gray
        self.isEnabled = false
        self.setTitle("Submit", for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        self.layer.cornerRadius = 25
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
       
        
        addTarget(self, action: #selector(didTouchDown), for: .touchDown)
        addTarget(self, action: #selector(didTouchUp), for: .touchUpInside)
    }
    
 
    func startLoading() {
        infinityShape = InfinityShape(frame: CGRect(x: 67.5, y: 12.5, width: 65, height: 25))
        self.addSubview(infinityShape!)
        self.titleLabel?.alpha = 0.0
    }
    
    func stopLoading() {
        self.titleLabel?.alpha = 1.0
        if let infinityShape = infinityShape {
            infinityShape.removeFromSuperview()
        }
    }
    
    @objc func didTouchDown() {
        self.backgroundColor = UIColor(red:0.13, green:0.53, blue:0.90, alpha:1.0)
    }
    
    @objc func didTouchUp() {
        
        //infinityShape.isHidden = false
        self.backgroundColor = UIColor(red:0.26, green:0.64, blue:0.96, alpha:1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
