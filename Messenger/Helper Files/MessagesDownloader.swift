//
//  MessagesDownloader.swift
//  Messenger
//
//  Created by Melinda Griswold on 9/17/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import Alamofire
import AVFoundation


class MessagesDownloader {
    
    weak var delegate: MessagesDownloaderDelegate? = nil
    var messages = [Message]()
    
    var username = ""
    
    var imagesToDownloadCount = 0
    
    func downloadImages() {
        
        for message in messages {
            if message.type == .image || message.type == .video {
                imagesToDownloadCount += 1
            }
        }
        
        for (index, message) in messages.enumerated() {
            if let imageURL = message.imageURL {
                downloadImage(link: imageURL, for: index)
            }
        }
    }
    
    func downloadImage(link: URL, for index: Int) {
        Alamofire.request(link).responseData { (response) in
            if response.error != nil {
                print("Unable to download image.")
            } else {
                
                guard let data = response.data else { return }
                guard let image = UIImage(data: data) else { return }
                
                DispatchQueue.main.async {
                    self.messages[index].image = image
                    self.imagesToDownloadCount -= 1
                    if self.imagesToDownloadCount == 0 {
                        self.delegate?.downloadEnded(messages: self.messages, username: self.username)
                    }
                }
            }
        }
    }
    
    func retreiveMessages(for username: String) {
        
        self.username = username
        let collectionRef = global.db.collection("users").document(username).collection("messages").order(by: "timestamp", descending: true)
        
        
        collectionRef.getDocuments()  { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    guard let type = data["type"] as? String else { continue }
                    
                    if type == "sending" || type == "receiving" {
                        
                        guard let text = data["text"] as? String else { continue }
                        let messageType: ChatCellType = type == "sending" ? .sending : .receiving
                        let message = Message(type: messageType, image: nil, text: text, video: nil)
                        self.messages.insert(message, at: 0)
                        
                    } else if type == "image" {
                        guard let imageUrl = data["imageURL"] as? String else { continue }
                        
                        let message = Message(type: .image, image: nil, text: nil, video: nil)
                        message.imageURL = URL(string: imageUrl)
                        self.messages.insert(message, at: 0)
                        
                    } else if type == "video" {
                        guard let imageUrl = data["imageURL"] as? String else { continue }
                        guard let videoUrl = data["videoURL"] as? String else { continue }
                        
                        let message = Message(type: .video, image: nil, text: nil, video: nil)
                        message.imageURL = URL(string: imageUrl)
                        message.videoURL = URL(string: videoUrl)
                        
                        self.messages.insert(message, at: 0)
                    }
                }
            }
            
            self.downloadImages()
        }
    }
    
}

protocol MessagesDownloaderDelegate: class {
    func downloadEnded(messages: [Message], username: String)
}
