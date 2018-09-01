//
//  PieChartCollectionViewCell.swift
//  Messenger
//
//  Created by Melinda Griswold on 8/29/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit
import Charts

class PieChartCollectionViewCell: UICollectionViewCell {
    
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
    
    private let chartView: PieChartView = {
        let chart = PieChartView()
        chart.chartDescription?.text = nil
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.legend.enabled = false
        chart.isUserInteractionEnabled = false 
        return chart
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.80
        label.textColor = .black
        label.text = "Pie Chart"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.textColor = .gray
        label.numberOfLines = 0
        label.text = "The tastiest chart. Great for visualizing how things are split."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    var backgroundViewMultiplier: CGFloat = 0.9
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        chartView.drawHoleEnabled = false
        [outerView, background].forEach { addSubview($0) }
        [chartView, subtitleLabel, titleLabel].forEach { background.addSubview($0) }
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

    func setDataCount(_ count: Int, range: UInt32) {
        
        
        let entry1 = PieChartDataEntry(value: 64, label: "Guys")
        let entry2 = PieChartDataEntry(value: 36, label: "Girls")
        let entries = [entry1, entry2]
        
        let set = PieChartDataSet(values: entries, label: nil)
        set.sliceSpace = 3
        set.colors = [UIColor(red:0.26, green:0.64, blue:0.96, alpha:1.0)]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 14, weight: .medium))
        data.setValueTextColor(.gray)
        
        chartView.data = data
        chartView.highlightValues(nil)
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
