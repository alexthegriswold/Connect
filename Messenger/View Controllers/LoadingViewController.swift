//
//  File.swift
//  Messenger
//
//  Created by Melinda Griswold on 8/29/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    let loadingView = LoadingView()

    var activeSecondsAllowed: TimeInterval = 5
    
    weak var delegate: LoadingViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(loadingView)
        
        setupAutoLayout()
        
        let _ = Timer.scheduledTimer(timeInterval: activeSecondsAllowed, target: self, selector: #selector(dismissView), userInfo: nil, repeats: false)
    }
    
    func setupAutoLayout() {
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3).isActive = true
        loadingView.heightAnchor.constraint(equalTo: loadingView.widthAnchor).isActive = true 
    }
    
    //MARK: Action Targets
    @objc func dismissView() {
        self.dismiss(animated: false, completion: {
            self.delegate?.loadingTimedOut()
        })
    }
}

protocol LoadingViewControllerDelegate: class {
    func loadingTimedOut()
}
