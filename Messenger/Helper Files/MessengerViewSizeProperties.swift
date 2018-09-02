//
//  MessengerViewSizeProperties.swift
//  Messenger
//
//  Created by Melinda Griswold on 9/1/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit

struct MessengerInputSizeComponents {
    
    let textViewHeight: CGFloat = 40
    let textViewBottomMargin: CGFloat = 10
    let textViewLeftMargin: CGFloat = 20
    let textViewRightMargin: CGFloat = 20
    let textViewBackgroundLeftMargin: CGFloat = 60
    let textViewBackgroundRightMargin: CGFloat = 10
    let actionButtonWidth: CGFloat = 40
    
    var safeAreaSize: CGFloat
    let textViewBackgroundCornerRadius: CGFloat
    let inputViewHeight: CGFloat
    
    init() {
        //check if iPhone X
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2436 {
               self.safeAreaSize = 34
            }
        } else {
            
        }
        
        self.textViewBackgroundCornerRadius = textViewHeight/2
        self.inputViewHeight = textViewHeight + textViewBottomMargin
        self.safeAreaSize = 0
        
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2436 {
                self.safeAreaSize = 34
            }
        }
    }
}
