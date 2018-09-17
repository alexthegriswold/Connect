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
    var image: UIImage?
    let text: String?
    var video: AVAsset?
    
    var imageURL: URL?
    var videoURL: URL?
    
    init(type: ChatCellType, image: UIImage? = nil, text: String? = nil, video: AVAsset? = nil) {
        self.type = type
        self.image = image
        self.text = text
        self.video = video
    }
}
