//
//  VideoPlayerViewController.swift
//  Messenger
//
//  Created by Melinda Griswold on 9/1/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class VideoPlayerViewController: UIViewController {
    
    var avPlayer: AVPlayer?
    var avPlayerLayer: AVPlayerLayer?
    var avPlayerItem: AVPlayerItem?
    
    //variables
    var paused: Bool = false
    
    let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        return imageView
    }()
    
    init(image: UIImage, video: AVAsset?, videoURL: URL? = nil) {
        
        super.init(nibName: nil, bundle: nil)
        
        if let video = video {
            setupVideoLayer(video: video)
        } else {
            
            view.addSubview(imageView)
            imageView.image = image
            imageView.frame = view.frame
            //load the video and get loading screen
            guard let url = videoURL else { return }
            guard let name = url.absoluteString.split(separator: "/").last else { return }
            downloadAndPlayVideo(url: url, with: String(name))
        }
    }
    
    func downloadAndPlayVideo(url: URL, with name: String) {
        
        Alamofire.request(url).downloadProgress(closure: { (progress) in
            print(progress)
        }).responseData { (response) in
            if let data = response.result.value {
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let videoURL = documentsURL.appendingPathComponent(name)
                do {
                    try data.write(to: videoURL)
                } catch {
                    return
                }
                
                let video = AVAsset(url: videoURL)
                self.setupVideoLayer(video: video)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avPlayer?.play()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.addGestureRecognizer(tapGestureRecognizer)
        let swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(dismissController))
        swipeDownGestureRecognizer.direction = .down
        view.addGestureRecognizer(swipeDownGestureRecognizer)
    }
    
    func setupVideoLayer(video: AVAsset) {
        
        avPlayerItem = AVPlayerItem(asset: video)
        avPlayer = AVPlayer(playerItem: avPlayerItem)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        
        if let avPlayerLayer = avPlayerLayer, let avPlayer = avPlayer {
            avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
            avPlayer.volume = 5
            avPlayer.actionAtItemEnd = .none
            
            avPlayerLayer.frame = view.layer.bounds
            view.backgroundColor = .white
            view.layer.insertSublayer(avPlayerLayer, at: 0)
            
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(playerItemDidReachEnd(notification:)),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                   object: avPlayer.currentItem)
        }
        
        avPlayer?.play()
        UIView.animate(withDuration: 0.25) {
            self.imageView.alpha = 0.0
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: kCMTimeZero)
    }
    
    @objc func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTap() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension VideoPlayerViewController: AVAssetDownloadDelegate {
    
}

