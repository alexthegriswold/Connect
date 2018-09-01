//
//  VideoPlayerViewController.swift
//  Messenger
//
//  Created by Melinda Griswold on 9/1/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerViewController: UIViewController {
    
    var avPlayer: AVPlayer
    var avPlayerLayer: AVPlayerLayer
    var avPlayerItem: AVPlayerItem
    
    //variables
    var paused: Bool = false
    
    init(video: AVAsset) {
        
        
        avPlayerItem = AVPlayerItem(asset: video)
        avPlayer = AVPlayer(playerItem: avPlayerItem)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        
        super.init(nibName: nil, bundle: nil)
        
        setupVideoLayer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avPlayer.play()
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.addGestureRecognizer(tapGestureRecognizer)
        let swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(dismissController))
        swipeDownGestureRecognizer.direction = .down
        view.addGestureRecognizer(swipeDownGestureRecognizer)
    }
    
    func setupVideoLayer() {
        
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
