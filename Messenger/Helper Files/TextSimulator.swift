//
//  TextSimulator.swift
//  Messenger
//
//  Created by Melinda Griswold on 9/1/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit

class TextSimulator {
    
    weak var delegate: TextSimulatorDelegate? = nil
    
    private var imageResponsesIndex = 0
    private var messageResponsesIndex = 0
    
    private let imageResponses = [
        "lol that's an amazing picture.",
        "wooooooooow",
        "I don't think I've ever seen something more beautiful.",
        "That's amazing",
        "This one is my favorite."
    ]
    
    private let messageResponses = [
        "Hey! I don't know what you're saying, but I'm going to respond anyway.",
        "You don't say?",
        "Yeah, I think so too",
        "Unfortunately, I'm not as smart as you think I am. I can't respond back intelligently.",
        "This was a super fun project. It took a lot longer than expected, but I defintely learned a ton.",
        "Yeah, I'm excited too."
    ]
    
    func giveResponse(to message: Message) {
        
        let now = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: now + 1) {
            if message.type == .image {
                let newMessage = self.getMessage(from: self.imageResponses, with: &self.imageResponsesIndex)
                self.delegate?.didRecieveText(message: newMessage)
            } else {
                let newMessage = self.getMessage(from: self.messageResponses, with: &self.messageResponsesIndex)
                self.delegate?.didRecieveText(message: newMessage)
            }
        }
    }
    
    private func getMessage(from array: [String], with index: inout Int) -> String {
        index = index >= (array.count - 1) ? 0 : index + 1
        return array[index]
    }
}

protocol TextSimulatorDelegate: class {
    func didRecieveText(message: String)
}
