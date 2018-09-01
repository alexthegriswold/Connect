//
//  ChatImageCollectionViewCell.swift
//  Messenger
//
//  Created by Melinda Griswold on 9/1/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit

class ChatImageCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: PhotoChatCellDelegate? = nil
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.autoresizesSubviews = true
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0).cgColor
        imageView.isUserInteractionEnabled = true 
        return imageView
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    
        [imageView].forEach { addSubview($0) }
        autoLayout()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTap() {
        delegate?.didTapCell(cell: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func autoLayout() {
        imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

protocol PhotoChatCellDelegate: class {
    func didTapCell(cell: ChatImageCollectionViewCell)
}

