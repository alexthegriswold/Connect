//
//  SenderChatCell.swift
//  Messenger
//
//  Created by Melinda Griswold on 8/30/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit

class SenderChatCell: UICollectionViewCell {
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byClipping
        return label
    }()
    
    let background: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 19
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0).cgColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didLongPress))
        background.addGestureRecognizer(gestureRecognizer)
        [background, textLabel].forEach { addSubview($0) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didLongPress() {
        print("copying text")
    }
}
