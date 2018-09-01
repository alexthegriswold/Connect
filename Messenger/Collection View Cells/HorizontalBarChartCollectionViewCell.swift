//
//  HorizontalBarChartCollectionViewCell.swift
//  Messenger
//
//  Created by Melinda Griswold on 8/29/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit
import Charts

class HorizontalBarChartCollectionViewCell: UICollectionViewCell {
    
    private let outerView: UIView = {
        let view = UIView()
        view.clipsToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 13
        view.layer.shouldRasterize = true
        return view
    }()
    
    private var background: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let chartView: HorizontalBarChartView = {
        let chart = HorizontalBarChartView()
        chart.chartDescription?.text = nil
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.isUserInteractionEnabled = false
        
        
        chart.scaleXEnabled = false
        chart.scaleYEnabled = false
        
        chart.drawValueAboveBarEnabled = true 
        
        chart.leftAxis.enabled = false
        chart.rightAxis.enabled = false
        chart.legend.enabled = false
        return chart
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.80
        label.textColor = .black
        label.text = "Horizontal Bar Chart"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.textColor = .gray
        label.numberOfLines = 0
        label.text = "This chart is good for something. Not sure for what though."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var backgroundViewMultiplier: CGFloat = 0.9
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        let xAxis = chartView.xAxis
        xAxis.axisLineColor = .lightGray
        xAxis.axisLineWidth = 0
        xAxis.gridLineWidth = 0
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10, weight: UIFont.Weight.regular)
        xAxis.labelTextColor = .lightGray
        xAxis.granularity = 1

        [outerView, background].forEach { addSubview($0) }
        [chartView, subtitleLabel, titleLabel].forEach { background.addSubview($0) }
        setupAutoLayout()
        
        setDataCount(8, range: 100)
        
        for set in chartView.data!.dataSets {
            set.drawIconsEnabled = true
            set.drawValuesEnabled = true
        }
        chartView.setNeedsDisplay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let width = self.frame.width * backgroundViewMultiplier
        let height = self.frame.height * backgroundViewMultiplier
        let xPoint = (self.frame.width - width)/2
        let yPoint = (self.frame.height - height)/2
        background.frame = CGRect(x: xPoint, y: yPoint, width: width, height: height)
        
        outerView.frame = background.frame
        outerView.layer.shadowPath = UIBezierPath(rect: outerView.bounds).cgPath
    }
    
    func setChartData(data: BarChartData) {
        chartView.data = data
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        let start = 1
        
        var yValsDict = [Double: Bool]()
        
        //for some reason the labels don't display when the y values are the same
        let yVals = (start..<start + count).map { (i) -> BarChartDataEntry in
            let mult = range + 1
            var val = Double(arc4random_uniform(mult))
            
            while yValsDict[val] != nil {
                val = Double(arc4random_uniform(mult))
            }
            
            yValsDict[val] = true
            
            print(val)
          
            return BarChartDataEntry(x: Double(i), y: val)
        }
        
        let set = BarChartDataSet(values: yVals, label: nil)
        set.colors = [UIColor(red:0.26, green:0.64, blue:0.96, alpha:1.0)]
        set.drawValuesEnabled = true
        set.drawIconsEnabled = true
    
        
        
        
        let data = BarChartData(dataSet: set)
        data.setValueFont(UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.regular))
        data.setValueTextColor(.lightGray)
        data.barWidth = 0.8
        
        let formatter = NumberFormatter()
        formatter.allowsFloats = false
        
    
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        chartView.data = data
    }
    
    private func setupAutoLayout() {
        
        background.widthAnchor.constraint(equalTo: widthAnchor, multiplier: backgroundViewMultiplier).isActive = true
        background.heightAnchor.constraint(equalTo: heightAnchor, multiplier: backgroundViewMultiplier).isActive = true
        background.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        background.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        chartView.widthAnchor.constraint(equalTo: chartView.heightAnchor).isActive = true
        chartView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 10).isActive = true
        chartView.centerXAnchor.constraint(equalTo: background.centerXAnchor).isActive = true
        chartView.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -10).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: background.topAnchor, constant: 20).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 33).isActive = true
        
        subtitleLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 20).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -20).isActive = true
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        subtitleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
