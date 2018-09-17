//
//  InfinityShape.swift
//  Messenger
//
//  Created by Melinda Griswold on 9/17/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit

class InfinityShape: UIView {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addShapeLayer()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //width == 125 height == 50
    //width == 75 height == 25
    func addShapeLayer() {
        
        let backLine = CAShapeLayer()
        let frontLine = CAShapeLayer()
        let background = CAShapeLayer()
        
        let newView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        newView.backgroundColor = .red
        
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: 25, y: 25))
        path1.addLine(to: CGPoint(x: 25, y: 50))
        path1.addLine(to: CGPoint(x: 100, y: 0))
        path1.addLine(to: CGPoint(x: 100, y: 25))
        path1.addLine(to: CGPoint(x: 100, y: 50))
        path1.addLine(to: CGPoint(x: 25, y: 0))
        path1.addLine(to: CGPoint(x: 25, y: 25))
        path1.close()
        
        path1.apply(CGAffineTransform(scaleX: 0.5, y: 0.5))
        
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: 0, y: 25))
        path2.addLine(to: CGPoint(x: 25, y: 50))
        path2.addLine(to: CGPoint(x: 100, y: 0))
        path2.addLine(to: CGPoint(x: 125, y: 25))
        path2.addLine(to: CGPoint(x: 100, y: 50))
        path2.addLine(to: CGPoint(x: 25, y: 0))
        path2.addLine(to: CGPoint(x: 0, y: 25))
        path2.close()
        
        path2.apply(CGAffineTransform(scaleX: 0.5, y: 0.5))
        
        let pathAnimation = CAKeyframeAnimation(keyPath: "path")
        pathAnimation.values = [path1.cgPath, path1.cgPath, path2.cgPath, path2.cgPath, path1.cgPath, path1.cgPath]
        pathAnimation.keyTimes = [0.0, 0.03, 0.07, 0.515, 0.555, 1.0]
        pathAnimation.duration = 4.0
        pathAnimation.repeatCount = .greatestFiniteMagnitude
        
        background.add(pathAnimation, forKey: "pathAnimation")
        frontLine.add(pathAnimation, forKey: "pathAnimation")
        backLine.add(pathAnimation, forKey: "pathAnimation")
        
        frontLine.strokeStart = 0.0
        frontLine.strokeEnd = 0.0
        
        backLine.strokeStart = 0.0
        backLine.strokeEnd = 0.0
        
        
        // 0.4 distance
        // 0.85 time
        
        //at 0.5 its at 0.76
        
        
        let easeInEaseOut = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        let linear = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        let timingFunctions = [easeInEaseOut, linear]
        
        let frontLineEndStroke = CAKeyframeAnimation(keyPath: "strokeEnd")
        frontLineEndStroke.values = [0.0, 0.6, 1.0]
        frontLineEndStroke.keyTimes = [0.0, 0.15, 1.0]
        frontLineEndStroke.duration = 2.0
        frontLineEndStroke.repeatCount = .greatestFiniteMagnitude
        frontLineEndStroke.timingFunctions = timingFunctions
        frontLine.add(frontLineEndStroke, forKey: "frontLineEndStroke")
        
        let frontLineStartStroke = CAKeyframeAnimation(keyPath: "strokeStart")
        frontLineStartStroke.values = [0.0, 0.235, 0.82, 0.9595]
        frontLineStartStroke.keyTimes = [0.0, 0.5, 0.65, 1.0]
        frontLineStartStroke.duration = 2.0
        frontLineStartStroke.repeatCount = .greatestFiniteMagnitude
        frontLineStartStroke.timingFunctions = [linear, easeInEaseOut, linear]
        frontLine.add(frontLineStartStroke, forKey: "frontLineStartStroke")
        
        background.fillColor = nil
        background.path = path1.cgPath
        background.strokeColor = UIColor.lightGray.cgColor
        background.lineWidth = 4
        background.lineCap = kCALineCapRound
        background.lineJoin = kCALineJoinRound
        
        backLine.fillColor = nil
        backLine.path = path1.cgPath
        backLine.strokeColor = UIColor.white.cgColor
        backLine.lineWidth = 4
        backLine.lineCap = kCALineCapRound
        backLine.lineJoin = kCALineJoinRound
        
        frontLine.path = path1.cgPath
        frontLine.fillColor = nil
        frontLine.lineWidth = 4
        frontLine.strokeColor = UIColor.white.cgColor
        frontLine.lineCap = kCALineCapRound
        frontLine.lineJoin = kCALineJoinRound
        
        
        self.layer.addSublayer(background)
        self.layer.addSublayer(frontLine)
        self.layer.addSublayer(backLine)
        
        self.addSubview(newView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
