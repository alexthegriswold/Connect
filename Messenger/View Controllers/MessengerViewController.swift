//
//  MessengerViewController.swift
//  Messenger
//
//  Created by Melinda Griswold on 8/30/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class MessengerViewController: UICollectionViewController {
    
    //data source
    var messages = [Message]()
    
    //views
    let messengerInputView = MessengerInputView()
    let actionButton = ActionButton()
    
    //view contraints
    var messengerInputViewBottomConstraint: NSLayoutConstraint?
    var actionButtonWidthConstraint: NSLayoutConstraint?
    
    //objects
    let username: String
    let authenicator = UserAuthenticator()
    let textSimulator = TextSimulator()
    
    let messagesManager: MessagesManager
    
    //override functions
    init(collectionViewLayout layout: UICollectionViewLayout, username: String) {
        self.username = username
        messagesManager = MessagesManager(username: username)
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Connect"
        
        messengerInputView.delegate = self
        actionButton.delegate = self
        textSimulator.delegate = self
        
        messengerInputView.setParentViewWidth(width: self.view.frame.width)
        [messengerInputView, actionButton].forEach { view.addSubview($0) }

        setupCollectionView()
        setupNavBar()
        setupAutoLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        actionButton.plusButton.addTarget(self, action: #selector(tappedActionButton), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.collectionView?.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        if let collectionView = collectionView {
            collectionView.removeConstraints(collectionView.constraints)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: messengerInputView.topAnchor).isActive = true
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            collectionView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 10, right: 0)
        }
    }
    
    @objc func dismissKeyboard() {
        self.messengerInputView.textView.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if messages.count > 0 {
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: false)
        }
    }
   
    //MARK: Collection View
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let message = messages[indexPath.item]
        
        let widthOfCell = view.frame.width * 0.7
        let size = CGSize(width: widthOfCell, height: 0)
        
        let attributes = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)]
        
        let text = message.text ?? ""
        
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
    
        let width = (estimatedFrame.size.width) + 32
        let height = estimatedFrame.height < 38 ? 38 : estimatedFrame.size.height + 32
        
        if message.type == .sending {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatCell", for: indexPath) as! ChatCollectionViewCell
            cell.textLabel.text = text
            cell.background.frame = CGRect(x: view.frame.width - width - 10, y: 0, width: width, height: height)
            cell.textLabel.frame = CGRect(x: view.frame.width - width + 7, y: 0, width: estimatedFrame.width, height: height)
            cell.delegate = self
            return cell
        } else if message.type == .receiving {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SenderCell", for: indexPath) as! SenderChatCell
            cell.textLabel.text = text
            cell.background.frame = CGRect(x: 10, y: 0, width: width, height: height)
            cell.textLabel.frame = CGRect(x: 26, y: 0, width: estimatedFrame.width, height: height)
            cell.delegate = self
            return cell
        } else  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ChatImageCollectionViewCell
            cell.imageView.image = message.image
            cell.delegate = self
            return cell
        }
    }
    
    //MARK: Helper functions
    func setupCollectionView() {
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = .white
        collectionView?.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: "ChatCell")
        collectionView?.register(SenderChatCell.self, forCellWithReuseIdentifier: "SenderCell")
        collectionView?.register(ChatImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
    }
    
    func addToMessages(message: Message) {
        
        
        messages.append(message)
        self.collectionView?.insertItems(at: [IndexPath(row: self.messages.count - 1, section: 0)])

        self.textSimulator.giveResponse(to: message)
    }
    
    //MARK: Action Listeners
    @objc func tappedActionButton() {
        
        if actionButton.expanded {
            self.actionButtonWidthConstraint?.constant = self.view.frame.width - 20
            self.messengerInputView.startTextViewHideAnimation()
            
            UIView.animate(withDuration: 0.20, delay: 0, options: .curveEaseIn, animations: {
                
                self.messengerInputView.textViewBackground.alpha = 0.0
                self.messengerInputView.textView.alpha = 0.0
                self.view.layoutIfNeeded()
                
            }, completion: nil)
        } else {
            
            self.actionButtonWidthConstraint?.constant = 40
            self.messengerInputView.undoTextViewHideAnimation()
            
            UIView.animate(withDuration: 0.20, delay: 0, options: .curveEaseIn, animations: {
                
                self.messengerInputView.textViewBackground.alpha = 1.0
                self.messengerInputView.textView.alpha = 1.0
                self.view.layoutIfNeeded()
                
            }, completion: nil)
        }
    }
    
    @objc func pushChartsViewController() {
        let viewController = AnalyticsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        self.view.endEditing(true)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func dismissViewController() {
        //TODO
        //authenicator.signOut(user: user)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Notification Listeners
    //This keeps the inputview to the top of the keyboard
    @objc func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            guard let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
            
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            let safeAreaHight = MessengerInputSizeComponents().safeAreaSize
            let topconstant = -keyboardFrame.height + safeAreaHight
            
            messengerInputViewBottomConstraint?.constant = isKeyboardShowing ? topconstant : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                
                self.view.layoutIfNeeded()
                
            }, completion: { (completed) in
                
                if isKeyboardShowing && !self.messages.isEmpty  {
                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                }
            })
        }
    }
    
    //MARK: Helper functions
    func setupNavBar() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Charts", style: .plain, target: self, action: #selector(pushChartsViewController))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "  Back", style: .plain, target: nil, action: nil)
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)]
        
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.13, green:0.53, blue:0.90, alpha:1.0)
    }
    
    func calculateCellHeight(with message: Message) -> CGSize {
        let widthOfCell = view.frame.width * 0.7
        let size = CGSize(width: widthOfCell, height: 0)
        
        let attributes = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)]
        let text = message.text ?? ""
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        let height = estimatedFrame.height < 38 ? 38 : estimatedFrame.size.height + 32
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    //MARK: Autolayout
    //we implement the resizing of the height in the view
    //only need to set the bottom, leading, and trailing constraints
    func setupAutoLayout() {
    
        let actionButtonBottomConstraintConstant = MessengerInputSizeComponents().safeAreaSize + MessengerInputSizeComponents().textViewBottomMargin
        actionButtonWidthConstraint = NSLayoutConstraint(item: actionButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
        actionButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: messengerInputView.bottomAnchor, constant: -actionButtonBottomConstraintConstant).isActive = true
        actionButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        actionButton.addConstraints([actionButtonWidthConstraint!])
        
        messengerInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        messengerInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        messengerInputViewBottomConstraint = NSLayoutConstraint(item: messengerInputView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
        view.addConstraint(messengerInputViewBottomConstraint!)
    }
}

extension MessengerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let message = messages[indexPath.row]
        
        if message.type == .image || message.type == .video {
            guard let image = message.image else { fatalError() }
            let width = self.view.frame.width * 0.7
            let ratio = image.size.height/image.size.width
            return CGSize(width: self.view.frame.width, height: width * ratio)
        } else {
            return calculateCellHeight(with: message)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
}

extension MessengerViewController: MessengerInputViewDelegate {
    func lineDidUpdate(offset: CGFloat) { }
    
    func didHitSend(message: String) {
        if message.count == 0 { return }
        
        let newMessage = Message(type: .sending, image: nil, text: message)
        addToMessages(message: newMessage)
        
        if messages.count > 0 {
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }
}


extension MessengerViewController: ActionButtonDelegate {
    func tappedImageButton() {
     
        let collectionView = PhotosGalleryViewController(collectionViewLayout: UICollectionViewFlowLayout(), isPhotoSelector: true)
        collectionView.delegate = self
        self.view.endEditing(true)
        self.navigationController?.pushViewController(collectionView, animated: true)
    }
    
    func tappedVideoButton() {
        let collectionView = PhotosGalleryViewController(collectionViewLayout: UICollectionViewFlowLayout(), isPhotoSelector: false)
        collectionView.delegate = self
        self.view.endEditing(true)
        self.navigationController?.pushViewController(collectionView, animated: true)
    }
    
    func tappedSpecialButton() {
        
    }
}

extension MessengerViewController: PhotosGalleryDelegate {

    func selectedPhoto(image: UIImage) {
    
        let newMessage = Message(type: .image, image: image, text: nil)
        addToMessages(message: newMessage)
        messagesManager.createNewMessage(message: newMessage, username: username)
        
    }
    
    func selectedVideo(video: AVAsset, image: UIImage, name: String, fileExtension: String) {
        let newMessage = Message(type: .video, image: image, text: nil, video: video)
        addToMessages(message: newMessage)
        
        let uploadInfo = [
            "name": name,
            "type": fileExtension
        ]
        messagesManager.createNewMessage(message: newMessage, username: username, uploadInfo: uploadInfo)
        
    }
}

extension MessengerViewController: MessageCellDelegate {
    func didLongPress(text: String) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let action = UIAlertAction(title: "Copy", style: .default) { (action) in
                let pasteboard = UIPasteboard.general
                pasteboard.string = text
            }
        alertController.addAction(action)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension MessengerViewController: TextSimulatorDelegate {
    func didRecieveText(message: String) {
        let newMessage = Message(type: .receiving, image: nil, text: message)
        messages.append(newMessage)
        messagesManager.createNewMessage(message: newMessage, username: username)
        collectionView?.insertItems(at: [IndexPath(row: messages.count - 1, section: 0)])
        
        if messages.count > 0 {
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }
}

extension MessengerViewController: PhotoChatCellDelegate {
    func didTapCell(cell: ChatImageCollectionViewCell) {
        
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        if messages[indexPath.item].type == .video {
            guard let video = messages[indexPath.item].video else { return }
            let videoViewController = VideoPlayerViewController(video: video)
            videoViewController.modalPresentationStyle = .currentContext
            self.present(videoViewController, animated: true, completion: nil)
        }
    }
}

