//
//  Message.swift
//  Messenger
//
//  Created by Melinda Griswold on 9/1/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit
import AVFoundation

class Message {
    let type: ChatCellType
    let image: UIImage?
    let text: String?
    
    init(type: ChatCellType, image: UIImage? = nil, text: String? = nil) {
        self.type = type
        self.image = image
        self.text = text
    }
}
