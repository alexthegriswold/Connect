//
//  MessengerViewController.swift
//  Messenger
//
//  Created by Melinda Griswold on 8/30/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import Foundation
import UIKit

class MessengerViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let smallString = "Hey its me! I thought that it would be fun to write a bit. I'm going to go right to the end. "
    let lotsOfWords = "It was the best of times, it was the worst of times, it was the age of wisdom, it was the age of foolishness, it was the epoch of belief, it was the epoch of incredulity, it was the season of Light, it was the season of Darkness, it was the spring of hope, it was the winter of despair, we had everything before us, we had nothing before us, we were all going direct to Heaven, we were all going direct the other way – in short, the period was so far like the present period, that some of its noisiest authorities insisted on its being received, for good or for evil, in the superlative degree of comparison only."
    
    var testString = ""
    
    
    let messsages: [(String, Bool)] = {
        var messages = [(String, Bool)]()
        messages.append(("Hey!", true))
        messages.append(("Hey! Whats up?", false))
        messages.append(("I really really need you.", true))
        messages.append(("What! Why?", false))
        messages.append(("I accidentally dropped the plate.", true))
        messages.append(("The one that my mom likes so much.", true))
        messages.append(("lol really?", false))
        messages.append(("I'm serious! This is a big problem.", true))
        messages.append(("ya ok", false))
        messages.append(("It was the best of times, it was the worst of times, it was the age of wisdom, it was the age of foolishness, it was the epoch of belief, it was the epoch of incredulity, it was the season of Light, it was the season of Darkness, it was the spring of hope, it was the winter of despair, we had everything before us, we had nothing before us, we were all going direct to Heaven, we were all going direct the other way – in short, the period was so far like the present period, that some of its noisiest authorities insisted on its being received, for good or for evil, in the superlative degree of comparison only.", true))
        messages.append(("Are you quoting a tale of two cities?", false))
        messages.append(("yes. I'm going to do it until you come over.", true))
        messages.append(("It was the best of times, it was the worst of times, it was the age of wisdom, it was the age of foolishness, it was the epoch of belief, it was the epoch of incredulity, it was the season of Light, it was the season of Darkness, it was the spring of hope, it was the winter of despair, we had everything before us, we had nothing before us, we were all going direct to Heaven, we were all going direct the other way – in short, the period was so far like the present period, that some of its noisiest authorities insisted on its being received, for good or for evil, in the superlative degree of comparison only.", true))
        messages.append(("Fine. I'll come over.", false))
        return messages
    }()
    
   
    //views
    let messengerInputView = MessengerInputView()
    var messengerInputViewBottomConstraint: NSLayoutConstraint?
    
    //MARK: View Controller override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messengerInputView.setParentViewWidth(width: self.view.frame.width)
        
        view.addSubview(messengerInputView)

        title = "Connect"
        collectionView?.alwaysBounceVertical = true 
        collectionView?.backgroundColor = .white
        collectionView?.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: "ChatCell")
         collectionView?.register(SenderChatCell.self, forCellWithReuseIdentifier: "SenderCell")
        
        //change
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50 + 10, right: 0)
        
        setupNavBar()
        setupAutoLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let indexPath = IndexPath(item: messsages.count - 1, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: false)
    }
   
    //MARK: Collection View
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        messengerInputView.textView.endEditing(true)
        let indexPath = IndexPath(item: messsages.count - 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messsages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let widthOfCell = view.frame.width * 0.7
        let size = CGSize(width: widthOfCell, height: 0)
        
        let attributes = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)]
        
        let estimatedFrame = NSString(string: messsages[indexPath.row].0).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        let width = (estimatedFrame.size.width) + 32
        let height = estimatedFrame.height < 38 ? 38 : estimatedFrame.size.height + 32
        
        if messsages[indexPath.row].1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatCell", for: indexPath) as! ChatCollectionViewCell
            cell.textLabel.text = messsages[indexPath.row].0
            cell.background.frame = CGRect(x: view.frame.width - width - 10, y: 0, width: width, height: height)
            cell.textLabel.frame = CGRect(x: view.frame.width - width + 7, y: 0, width: estimatedFrame.width, height: height)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SenderCell", for: indexPath) as! SenderChatCell
            cell.textLabel.text = messsages[indexPath.row].0
            cell.background.frame = CGRect(x: 10, y: 0, width: width, height: height)
            cell.textLabel.frame = CGRect(x: 26, y: 0, width: estimatedFrame.width, height: height)
            
            return cell
        }
    }
    
    //MARK: CollectionView Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthOfCell = view.frame.width * 0.7
        let size = CGSize(width: widthOfCell, height: 0)
        
        let attributes = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)]
        
        let estimatedFrame = NSString(string: messsages[indexPath.row].0).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        let height = estimatedFrame.height < 38 ? 38 : estimatedFrame.size.height + 32
    
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
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
                
                if isKeyboardShowing {
                    let indexPath = IndexPath(item: self.messsages.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                }
            })
        }
    }
    
    //MARK: Helper functions
    func setupNavBar() {
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "  Back", style: .plain, target: nil, action: nil)
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)]
        
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
    }
    
    //MARK: Autolayout
    //we implement the resizing of the height in the view
    //only need to set the bottom, leading, and trailing constraints
    func setupAutoLayout() {
    
        messengerInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        messengerInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        messengerInputViewBottomConstraint = NSLayoutConstraint(item: messengerInputView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
        view.addConstraint(messengerInputViewBottomConstraint!)
    }
}
