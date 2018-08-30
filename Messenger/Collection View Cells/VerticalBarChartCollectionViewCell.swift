//
//  VerticalBarChartCollectionViewCell.swift
//  Messenger
//
//  Created by Melinda Griswold on 8/29/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit
import Charts

class VerticalBarChartCollectionViewCell: UICollectionViewCell {
    
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
    
    private let chartView: BarChartView = {
        let chart = BarChartView()
        chart.chartDescription?.text = nil
        chart.translatesAutoresizingMaskIntoConstraints = false
        
        chart.isUserInteractionEnabled = false
        
        chart.leftAxis.enabled = false
        chart.rightAxis.enabled = false
        chart.legend.enabled = false
        
        chart.drawValueAboveBarEnabled = true
        
        return chart
    }()
    
    var backgroundViewMultiplier: CGFloat = 0.9
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    
        
        print(chartView.drawValueAboveBarEnabled)
        
        let xAxis = chartView.xAxis
        xAxis.axisLineColor = .lightGray
        xAxis.axisLineWidth = 0
        xAxis.gridLineWidth = 0
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10, weight: UIFont.Weight.regular)
        xAxis.labelTextColor = .lightGray
        xAxis.granularity = 1

        [outerView, background].forEach { addSubview($0) }
        background.addSubview(chartView)
        setupAutoLayout()
        
        setDataCount(4, range: 100)
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
        
        let yVals = (start..<start + count).map { (i) -> BarChartDataEntry in
            let mult = range + 1
            let val = Double(arc4random_uniform(mult))
            return BarChartDataEntry(x: Double(i), y: val)
        }
        
        let set = BarChartDataSet(values: yVals, label: nil)
        set.colors = [.cyan]
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
        
        chartView.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 10).isActive = true
        chartView.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -10).isActive = true
        chartView.topAnchor.constraint(equalTo: background.topAnchor, constant: 10).isActive = true
        chartView.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -10).isActive = true
    }
}
