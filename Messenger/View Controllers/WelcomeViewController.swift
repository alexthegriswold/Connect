//
//  ViewController.swift
//  Messenger
//
//  Created by Alexander Griswold on 8/25/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit
import AVFoundation

class WelcomeViewController: UIViewController, WelcomeViewDelegate, UINavigationControllerDelegate {
    
    let authenticator = UserAuthenticator()
    
    //views
    let loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let welcomeView = WelcomeView()
    var avPlayer: AVPlayer
    var avPlayerLayer: AVPlayerLayer
    
    //variables
    var paused: Bool = false
    
    var statusBarHidden = false
    
    //MARK: Init
    init() {
        guard let url = Bundle.main.url(forResource: "backgroundVideo", withExtension: "mp4") else { fatalError() }
        avPlayer = AVPlayer(url: url)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        super.init(nibName: nil, bundle: nil)
        
        welcomeView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeView.frame = self.view.frame
        [welcomeView].forEach { view.addSubview($0) }
        setupVideoLayer()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "  Back", style: .plain, target: nil, action: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        
        navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let user = authenticator.checkIfLoggedIn() {
            let messengerViewController = MessengerViewController(collectionViewLayout: UICollectionViewFlowLayout(), user: user)
            let navigationController = UINavigationController(rootViewController: messengerViewController)
            self.present(navigationController, animated: false, completion: nil)
        } else {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            welcomeView.signUp.titleLabel?.alpha = 1.0
            welcomeView.login.alpha = 1.0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Show the status bar
        statusBarHidden = false
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    //Mark: Helper Functions
    func setupVideoLayer() {
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = .none
        
        avPlayerLayer.frame = view.layer.bounds
        view.backgroundColor = .clear
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer.currentItem)
    }

    @objc func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: kCMTimeZero)
    }
    
    
    
    //MARK: WelcomeViewDelegate
    func didTapSignUp() {
        print("HEY")
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    func didTapLogin() {
        print("HEY")
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
    //MARK: UIApplicationDidBecomeActive Observer
    @objc func applicationDidBecomeActive() {
        avPlayer.play()
        paused = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        
        if operation == .push {
            statusBarHidden = true
            
            if let _ = toVC as? SignUpViewController {
                return SignUpAnimationController(presenting: true)
            } else {
                return LoginAnimationController(presenting: true)
            }
            
        } else {
            if let _ = fromVC as? SignUpViewController {
                return SignUpAnimationController(presenting: false)
            } else {
                return LoginAnimationController(presenting: false)
            }
        }
    }
}




