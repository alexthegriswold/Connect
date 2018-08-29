//
//  SignUpAnimationController.swift
//  Messenger
//
//  Created by Melinda Griswold on 8/28/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit

class SignUpAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let presenting: Bool
    
    let buttonView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        view.frame.size = CGSize(width: 200, height: 50)
        return view
    }()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return presenting ? 0.30 : 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        let container = transitionContext.containerView
        
        
        let overlay = UIVisualEffectView()
        overlay.frame = container.frame
        
        let centerY = container.frame.height/2.0
        let centerX = container.frame.width/2.0
        let center = CGPoint(x: centerX, y: centerY)
        buttonView.center = center
        
        let title = UILabel()
        title.textColor = .black
        title.text = "Sign Up"
        title.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        title.frame.size = CGSize(width: 200, height: 50)
        title.center = center
        title.textAlignment = .center
        title.alpha = 0.0
        
        if presenting {
            [overlay, buttonView, toView].forEach { container.addSubview($0) }
            toView.alpha = 0.0
        
        } else {
            buttonView.frame = container.frame
            overlay.effect = UIBlurEffect(style: .dark)
            [toView, fromView, overlay, buttonView].forEach { container.addSubview($0) }
        }
        
        
        if presenting {
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                overlay.effect = UIBlurEffect(style: .dark)
                self.buttonView.frame = container.frame
                
                //check if iPhone X
                if UIDevice().userInterfaceIdiom == .phone {
                    switch UIScreen.main.nativeBounds.height {
                    case 2436:
                        break
                    default:
                        self.buttonView.layer.cornerRadius = 0
                    }
                }
                
            }, completion: { _ in
                
                UIView.animate(withDuration: 0.25, animations: {
                    toView.alpha = 1.0
                }, completion: { _ in
                    let success = !transitionContext.transitionWasCancelled
                    if !success {
                        toView.removeFromSuperview()
                    }
                    transitionContext.completeTransition(success)
                })
            })
            
        } else {
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                overlay.effect = nil
                fromView.alpha = 0.0
                self.buttonView.frame.size = CGSize(width: 200, height: 50)
                self.buttonView.center = center
                self.buttonView.layer.cornerRadius = 25
                
            }, completion: { _ in
                
                let success = !transitionContext.transitionWasCancelled
                if !success {
                    toView.removeFromSuperview()
                }
                self.buttonView.removeFromSuperview()
                title.removeFromSuperview()
                overlay.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        }
    }
    
    init(presenting: Bool) {
        self.presenting = presenting
    }
}
