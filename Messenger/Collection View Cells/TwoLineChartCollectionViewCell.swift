//
//  TwoLineChartCollectionViewCell.swift
//  Messenger
//
//  Created by Melinda Griswold on 8/29/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit
import Charts

class TwoLineChartCollectionViewCell: UICollectionViewCell {
    
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
    
    private let chartView: LineChartView = {
        let chart = LineChartView()
        chart.chartDescription?.text = nil
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.isUserInteractionEnabled = false
        
        let grayColor = UIColor(white: 0.90, alpha: 1.0)
        let labelFont = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.regular)
        let labelTextColor = UIColor.gray
        
        //right axis
        chart.rightAxis.enabled = false
        
        //left axis
        let leftAxis = chart.leftAxis
        leftAxis.gridColor = grayColor
        leftAxis.axisLineColor = grayColor
        leftAxis.axisMinimum = 0
        leftAxis.labelFont = labelFont
        leftAxis.labelTextColor = labelTextColor
        
        //x axis
        let xAxis = chart.xAxis
        xAxis.gridColor = grayColor
        xAxis.axisLineColor = grayColor
        xAxis.labelPosition = .bottom
        xAxis.labelFont = labelFont
        xAxis.labelTextColor = labelTextColor
        
        chart.legend.enabled = false
        
        return chart
    }()
    
    var backgroundViewMultiplier: CGFloat = 0.9
    
    let lineChartData: LineChartData = {
        var dataEntries = [ChartDataEntry]()
        
        for i in 0...10 {
            dataEntries.append(ChartDataEntry(x: Double(i), y: Double(i)))
        }
        
        let dataSet = LineChartDataSet(values: dataEntries, label: "AYYY")
        dataSet.drawCircleHoleEnabled = false
        dataSet.circleRadius = 5
        
        dataSet.colors = [.cyan]
        dataSet.valueFont = .systemFont(ofSize: 10, weight: UIFont.Weight.regular)
        dataSet.valueTextColor = .cyan
        dataSet.circleColors = [.cyan]
        
        var dataEntries2 = [ChartDataEntry]()
        
        for i in 0...10 {
            dataEntries2.append(ChartDataEntry(x: Double(i), y: Double(10 - i)))
        }
        
        let dataSet2 = LineChartDataSet(values: dataEntries2, label: "YOOO")
        dataSet2.drawCircleHoleEnabled = false
        dataSet2.circleRadius = 5
        
        dataSet2.colors = [.green]
        dataSet2.valueFont = .systemFont(ofSize: 10, weight: UIFont.Weight.regular)
        dataSet2.valueTextColor = .green
        dataSet2.circleColors = [.green]
        
        let data = LineChartData()
        
        data.addDataSet(dataSet)
        data.addDataSet(dataSet2)
        return data
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        [outerView, background].forEach { addSubview($0) }
        background.addSubview(chartView)
        setupAutoLayout()
        
        setChartData(data: lineChartData)
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
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setChartData(data: LineChartData) {
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
