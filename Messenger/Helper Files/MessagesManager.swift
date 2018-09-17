//
//  MessagesManager.swift
//  Messenger
//
//  Created by Melinda Griswold on 9/16/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore
import AVFoundation

class MessagesManager {
    
    var messages = [Message]()
    
    let username: String
    
    init(username: String) {
        self.username = username
    }

    //the way that each thing is going to work
    //the image will get added locally as normal
    //text will get uploaded to the database
    //image and videos will have links to the video and image
    //images get downloaded but videos will only be downloaded when tapped
    
    func uploadImage(image: UIImage, timestamp: Timestamp) {
        let storageRef = global.storage.reference()
    
        guard let data = UIImageJPEGRepresentation(image, 1.0) else { return }
        let timeStampNanoSeconds = Timestamp.init(date: Date()).nanoseconds
        
        let fileRef = storageRef.child("\(username)/images/\(timeStampNanoSeconds).jpg")
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        
        
        fileRef.putData(data, metadata: uploadMetadata) { (metadata, error) in
           
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            fileRef.downloadURL(completion: { (url, error) in
                guard error == nil else {
                    print(error?.localizedDescription ?? "")
                    return
                }
                
                if let url = url {
                    self.updateImageDownloadURL(downloadUrl: url, timestamp: timestamp)
                }
            })
        }
    }
    
    func updateImageDownloadURL(downloadUrl: URL, timestamp: Timestamp) {
        let collectionRef = global.db.collection("messages")
        let query = collectionRef
            .whereField("timestamp", isEqualTo: timestamp)
            .whereField("username", isEqualTo: username)
        
        query.getDocuments { (documents, error) in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            
            let document = documents?.documents.first
            guard let id = document?.documentID else { return }
            
            let collectionRef = global.db.collection("messages").document(id)
            collectionRef.updateData(["imageURL": downloadUrl
                .absoluteString])
            
        }
    }
    
    func updateVideoDownloadURL(downloadUrl: URL, timestamp: Timestamp) {
        let collectionRef = global.db.collection("messages")
        let query = collectionRef
            .whereField("timestamp", isEqualTo: timestamp)
            .whereField("username", isEqualTo: username)
        
        query.getDocuments { (documents, error) in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            
            let document = documents?.documents.first
            guard let id = document?.documentID else { return }
            
            let collectionRef = global.db.collection("messages").document(id)
            collectionRef.updateData(["videoURL": downloadUrl
                .absoluteString])
        }
    }
    
    func uploadVideo(with url: URL, name: String, type: String, timestamp: Timestamp) {
     
        let storageRef = global.storage.reference()
        let fileRef = storageRef.child("\(username)/videos/\(name)")
        let metadata = StorageMetadata()
        
        var fileType = type.lowercased()
        
        fileType = fileType == "mp4" ? "mp4" : "quicktime"
        
        metadata.contentType = "video/\(fileType)"
        let uploadTask = fileRef.putFile(from: url, metadata: metadata) { ( responseMetadata, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            fileRef.downloadURL(completion: { (url, error) in
                guard error == nil else {
                    print(error?.localizedDescription ?? "")
                    return
                }
                
                if let url = url {
                    self.updateVideoDownloadURL(downloadUrl: url, timestamp: timestamp)
                }
            })
        }
        
        uploadTask.observe(.progress) { (snapshot) in
            guard let progress = snapshot.progress else { return }
            print(progress.fractionCompleted)
        }
        
    }
    
    func saveVideoToURL(video: AVAsset, name: String, type: String, timestamp: Timestamp) {
        
        let fileManager = FileManager.default
        let docDir = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let videoURL = docDir.appendingPathComponent(name)
    
        
        if fileManager.fileExists(atPath: videoURL.path) {
            print("that file is already there!")
            self.uploadVideo(with: videoURL, name: name, type: type, timestamp: timestamp)
        } else {
            
            print("that file not already there!")
            let exportSession = AVAssetExportSession(asset: video, presetName: AVAssetExportPresetMediumQuality)
            exportSession?.outputFileType = getAVFileType(for: type)
            exportSession?.outputURL = videoURL
            exportSession?.exportAsynchronously(completionHandler: {
                
                DispatchQueue.main.async {
                    self.uploadVideo(with: videoURL, name: name, type: type, timestamp: timestamp)
                }
            })
        }
    }
    
    func getAVFileType(for fileExtension: String) -> AVFileType {
        let fileExt = fileExtension.lowercased()
        
        switch fileExtension {
        case "mp4":
            return AVFileType.mp4
        default:
            return AVFileType.mov
        }
    }
    
    
    //we need the image name and extension
    //we need video name and extension
    func createNewMessage(message: Message, username: String, uploadInfo: [String: Any]? = nil) {
        let type = message.type
        let collectionRef = global.db.collection("messages")
        let timestamp = Timestamp(date: Date())
        
        if type == .sending || type == .receiving {
            collectionRef.addDocument(data: [
                "type" : type.rawValue,
                "text" : message.text!,
                "timestamp" : timestamp,
                "username" : username
            ])
        } else if type == .image {
            guard let image = message.image else { return }
            
            collectionRef.addDocument(data: [
                "type" : type.rawValue,
                "timestamp" : timestamp,
                "username" : username
            ]) { (error) in
                if error == nil {
                    self.uploadImage(image: image, timestamp: timestamp)
                }
            }
        } else if type == .video {
            guard let image = message.image else { return }
            guard let video = message.video else { return }
            guard let videoName = uploadInfo?["name"] as? String else { return }
            guard let videoType = uploadInfo?["type"] as? String else { return }
            
            collectionRef.addDocument(data: [
                "type" : type.rawValue,
                "timestamp" : timestamp,
                "username" : username
            ]) { (error) in
                if error == nil {
                    self.uploadImage(image: image, timestamp: timestamp)
                    self.saveVideoToURL(video: video, name: videoName, type: videoType, timestamp: timestamp)
                }
            }
        }
    }
}
