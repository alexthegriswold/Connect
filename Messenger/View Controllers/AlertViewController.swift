//
//  AlertViewController.swift
//  Messenger
//
//  Created by Melinda Griswold on 8/28/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    let alertView: AlertView
    weak var delegate: AlertViewControllerDelegate? = nil
    
    init(viewModel: AlertViewModel) {
        alertView = AlertView(viewModel: viewModel)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        super.init(nibName: nil, bundle: nil)
        
        alertView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        self.view.addSubview(alertView)
        
        alertView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        alertView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.70).isActive = true
        alertView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        alertView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
}

protocol AlertViewControllerDelegate: class {
    func alertIsDismissing()
    func alertDidDismiss()
}

extension AlertViewController: AlertViewButtonDelegate {
    func didTapAlertButton() {
        self.delegate?.alertIsDismissing()
        self.dismiss(animated: true, completion: {
            self.delegate?.alertDidDismiss()
        })
    }
}
