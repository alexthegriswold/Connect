//
//  AlertView.swift
//  Messenger
//
//  Created by Melinda Griswold on 8/28/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit

class AlertView: UIView {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.bold)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var subtitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        button.backgroundColor = .black
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var delegate: AlertViewButtonDelegate? = nil
    
    //var alertViewModel: AlertViewModel?
    
    init(viewModel: AlertViewModel) {
        
        titleLabel.text = viewModel.title
        subtitle.text = viewModel.subtitle
        button.setTitle(viewModel.buttonTitle, for: .normal)
        
        super.init(frame: .zero)
        self.backgroundColor = UIColor.white
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 15
        
        [titleLabel, subtitle, button].forEach { addSubview($0) }
        
        setupAutoLayout()
        
        button.addTarget(self, action: #selector(AlertView.didTapButton), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAutoLayout() {
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        subtitle.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8).isActive = true
        subtitle.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        subtitle.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -20).isActive = true
        subtitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        button.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    @objc func didTapButton() {
        delegate?.didTapAlertButton()
    }
}

protocol AlertViewButtonDelegate: class {
    func didTapAlertButton()
}
