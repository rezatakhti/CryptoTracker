//
//  GraphChildViewController.swift
//  CurrencyTracker
//
//  Created by Reza Takhti on 2/10/20.
//  Copyright © 2020 Reza Takhti. All rights reserved.
//

import UIKit
import Charts

protocol GraphViewDelegate : class {
    func amountLabelShouldChange(value: Double)
    func calculatedPercentChange(value: Double)
}

class GraphChildViewController: UIViewController {
    
    var lineChartView = LineChartView()
    
    var panGestureRecognizer : UIPanGestureRecognizer!
    var prices = [Double]()
    weak var delegate : GraphViewDelegate? {
        didSet {
            calculatePercentChange(prices: prices)
            guard prices.count > 1 else { return }
            delegate?.amountLabelShouldChange(value: prices.first!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        for _ in 0..<50 {
            prices.append(8000 + Double(arc4random_uniform(1000)))
        }
        
        
        setChart(values: prices)
    }
    
    private func calculatePercentChange(prices: [Double]){
        guard prices.count > 1 else { return }
        
        let startPrice = prices.first!
        let endPrice = prices.last!
        
        let percentage = endPrice / startPrice * 100
        let calculatedPercentage = percentage > 100 ? percentage - 100 : -(100 - percentage)
        
        delegate?.calculatedPercentChange(value: calculatedPercentage)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLineChartView()
        lineChartView.animate(xAxisDuration: 1, easingOption: .easeOutSine)
    }
    
    
    private func setupLineChartView(){
        view.addSubview(lineChartView)
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.delegate = self
        NSLayoutConstraint.activate([
            lineChartView.topAnchor.constraint(equalTo: view.topAnchor),
            lineChartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lineChartView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lineChartView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setChart(values: [Double]) {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<values.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Units Sold")
        let lineChartsData = LineChartData()
        lineChartsData.addDataSet(lineChartDataSet)
        
        lineChartDataSet.colors = [.white]
        
        lineChartDataSet.drawCirclesEnabled = false
        
        let gradientColors = [UIColor.white.cgColor, UIColor.clear.cgColor]
        let colorLocations : [CGFloat] = [1.0, 0.0]
        guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors as CFArray, locations: colorLocations) else {
            print("error")
            return
        }
  
        lineChartDataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        lineChartDataSet.drawFilledEnabled = true
        lineChartDataSet.mode = .cubicBezier
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.highlightEnabled = true
        lineChartDataSet.setDrawHighlightIndicators(true)
        lineChartDataSet.highlightLineWidth = 1
        lineChartDataSet.highlightColor = .white
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        lineChartDataSet.lineWidth = 2

        
        
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        
        lineChartView.legend.enabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.drawLabelsEnabled = false
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.axisLineColor = .white
        lineChartView.leftAxis.axisLineColor = .white
        lineChartView.leftAxis.axisLineWidth = 2
        lineChartView.xAxis.axisLineWidth = 2
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.data = lineChartsData
        lineChartView.highlightPerTapEnabled = false
        lineChartView.highlightPerDragEnabled = true
        lineChartView.scaleYEnabled = false
        lineChartView.scaleXEnabled = false
    }
    


}

extension GraphChildViewController : ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry.y)
        delegate?.amountLabelShouldChange(value: entry.y)
        guard prices.count > 1 else { return }
        calculatePercentChange(prices:  [prices.first!, entry.y])
       
    }
    func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        calculatePercentChange(prices: prices)
        chartView.highlightValue(nil)
        guard prices.count > 1 else { return }
        delegate?.amountLabelShouldChange(value: prices.last!)
    }
}


