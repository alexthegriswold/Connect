//
//  FormInputItem.swift
//  Messenger
//
//  Created by Melinda Griswold on 8/27/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit

class FormInputItem: UIView {
    
    weak var delegate: FormInputItemDelegate? = nil
    
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 10
        textField.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        textField.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.regular)
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 45))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.returnKeyType = .next
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    init(frame: CGRect, itemTitle: String) {
        super.init(frame: frame)
        
        self.title.text = itemTitle
        
        //add subviews
        [title, textField].forEach { addSubview($0) }
        
        //auto layout
        setupAutoLayout()
        
        //add targets
        textField.addTarget(self, action: #selector(primaryActionTriggered), for: .primaryActionTriggered)
        textField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Auto Layout
    func setupAutoLayout() {
        title.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        title.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        title.heightAnchor.constraint(equalToConstant: 20).isActive = true
        title.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        textField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        heightAnchor.constraint(equalToConstant: 80).isActive = true 
    }
    
    @objc func primaryActionTriggered() {
        delegate?.primaryActionTriggered(returnType: textField.returnKeyType)
    }
   
    @objc func editingChanged() {
        delegate?.editingChanged()
    }
}

protocol FormInputItemDelegate: class {
    func primaryActionTriggered(returnType: UIReturnKeyType)
    func editingChanged()
}
