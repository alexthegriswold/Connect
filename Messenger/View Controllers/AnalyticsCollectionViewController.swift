//
//  AnalyticsCollectionViewController.swift
//  Messenger
//
//  Created by Melinda Griswold on 8/29/18.
//  Copyright © 2018 com.MobilePic. All rights reserved.
//

import UIKit
import Charts

class AnalyticsCollectionViewController: UICollectionViewController {
    
    //data source
    let datasource = [AnalyticsChartType.pieChart, AnalyticsChartType.twoLine, AnalyticsChartType.singleLine, AnalyticsChartType.verticalBar, AnalyticsChartType.horizontalBar]
    
    //override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Analytics"
        setupCollectionView()
        setupNavBar()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellType = datasource[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.rawValue, for: indexPath)
        
        return cell
    }
    
    //MARK: Helper functions
    func setupCollectionView() {
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = .white
        collectionView?.register(TwoLineChartCollectionViewCell.self, forCellWithReuseIdentifier: "TwoLineChartCollectionViewCell")
        collectionView?.register(SingleLineChartCollectionViewCell.self, forCellWithReuseIdentifier: "SingleLineChartCollectionViewCell")
        collectionView?.register(VerticalBarChartCollectionViewCell.self, forCellWithReuseIdentifier: "VerticalBarChartCollectionViewCell")
        collectionView?.register(HorizontalBarChartCollectionViewCell.self, forCellWithReuseIdentifier: "HorizontalBarChartCollectionViewCell")
        collectionView?.register(PieChartCollectionViewCell.self, forCellWithReuseIdentifier: "PieChartCollectionViewCell")
    }

    func setupNavBar() {
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "  Back", style: .plain, target: nil, action: nil)
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)]
        
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.13, green:0.53, blue:0.90, alpha:1.0)
    }
}

extension AnalyticsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.width * 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
