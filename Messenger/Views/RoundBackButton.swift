//
//  RoundBackButton.swift
//  Messenger
//
//  Created by Melinda Griswold on 8/28/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit

class RoundBackButton: UIButton {
    
    let path = UIBezierPath()
    let fillLayer = CAShapeLayer()
    let xOffset: CGFloat
    let yOffset: CGFloat
    let buttonRadius: CGFloat = 175.0
    let scale: CGFloat
    var circleColor = UIColor.darkGray
    
    let blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark))
    
    init(frame: CGRect, width: CGFloat, color: UIColor? = nil) {
        
        if let color = color {
            circleColor = color
        }
        
        var buttonOriginalWidth = buttonRadius * 2
        scale = width/buttonOriginalWidth
        
        xOffset = buttonRadius
        yOffset = buttonRadius
        
        super.init(frame: frame)

        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: buttonRadius, y: buttonRadius), radius: buttonRadius, startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        
        circlePath.apply(CGAffineTransform.init(scaleX: scale, y: scale))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = circleColor.cgColor
        
        self.layer.addSublayer(shapeLayer)
        
        //front left
        path.move(to: CGPoint(x: 0 + xOffset, y: 20 + yOffset))
        path.addLine(to: CGPoint(x: 40 + xOffset, y: 60 + yOffset))
        path.addCurve(to: CGPoint(x: 60 + xOffset, y: 40 + yOffset), controlPoint1: CGPoint(x: 56 + xOffset, y: 76 + yOffset), controlPoint2: CGPoint(x: 76 + xOffset, y: 56 + yOffset))
        path.addLine(to: CGPoint(x: 20 + xOffset, y: 0 + yOffset))
        path.addLine(to: CGPoint(x: 60 + xOffset, y: -40 + yOffset))
        path.addCurve(to: CGPoint(x: 40 + xOffset, y: -60 + yOffset), controlPoint1: CGPoint(x: 76 + xOffset, y: -56 + yOffset), controlPoint2: CGPoint(x: 56 + xOffset, y: -76 + yOffset))
        path.addLine(to: CGPoint(x: 0 + xOffset, y: -20 + yOffset))
        path.addLine(to: CGPoint(x: -40 + xOffset, y: -60 + yOffset))
        path.addCurve(to: CGPoint(x: -60 + xOffset, y: -40 + yOffset), controlPoint1: CGPoint(x: -56 + xOffset, y: -76 + yOffset), controlPoint2: CGPoint(x: -76 + xOffset, y: -56 + yOffset))
        path.addLine(to: CGPoint(x: -20 + xOffset, y: 0 + yOffset))
        path.addLine(to: CGPoint(x: -60 + xOffset, y: 40 + yOffset))
        path.addCurve(to: CGPoint(x: -40 + xOffset, y: 60 + yOffset), controlPoint1: CGPoint(x: -76 + xOffset, y: 56 + yOffset), controlPoint2: CGPoint(x: -56 + xOffset, y: 76 + yOffset))
        path.addLine(to: CGPoint(x: 0 + xOffset, y: 20 + yOffset))
        
        path.close()
        
        path.apply(CGAffineTransform.init(scaleX: scale, y: scale))
        UIColor.clear.set()
        path.fill()
        
        
        fillLayer.path = path.cgPath;
        fillLayer.fillColor = UIColor.white.cgColor
        self.layer.addSublayer(fillLayer)
    }
}
