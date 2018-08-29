//
//  AlertViewModel.swift
//  Messenger
//
//  Created by Melinda Griswold on 8/28/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit

class AlertViewModel {
    let title: String
    let subtitle: String
    let buttonTitle: String
    
    init(title: String, subtitle: String, buttonTitle: String) {
        self.title = title
        self.subtitle = subtitle
        self.buttonTitle = buttonTitle
    }
}
