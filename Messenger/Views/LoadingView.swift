//
//  LoadingView.swift
//  Messenger
//
//  Created by Melinda Griswold on 8/29/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    init() {
        super.init(frame: .zero)
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 15
        self.backgroundColor = .white
        
        self.addSubview(activityIndicator)
        self.activityIndicator.startAnimating()
        
        setupAutoLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAutoLayout() {
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
}
