//
//  LoginAnimationController.swift
//  Messenger
//
//  Created by Melinda Griswold on 8/28/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit

class LoginAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let presenting: Bool
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return presenting ? 0.365 : 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        
        let container = transitionContext.containerView
        
        if presenting {
            [fromView, toView].forEach { container.addSubview($0) }
            toView.alpha = 0.0
        } else {
            [toView, fromView].forEach { container.addSubview($0) }
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            
            if self.presenting {
                toView.alpha = 1.0
            } else {
                fromView.alpha = 0.0
            }
            
        }, completion: { _ in
            
            let success = !transitionContext.transitionWasCancelled
            if !success {
                toView.removeFromSuperview()
            }
            transitionContext.completeTransition(success)
        })
    }
    
    init(presenting: Bool) {
        self.presenting = presenting
    }
}
