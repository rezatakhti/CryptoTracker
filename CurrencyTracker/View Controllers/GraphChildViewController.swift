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
    func animateLabels()
}

class GraphChildViewController: UIViewController {
    
    var lineChartView = LineChartView()
    var cryptoID : String?
    
    var panGestureRecognizer : UIPanGestureRecognizer!
    var priceDictionary = [Double : Int]()
    var prices = [Double]()
    var numOfDaysBeingDisplayed = 1
    let dateLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    weak var delegate : GraphViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFloatingLabel()
        makeNetworkCalls(days: 1)
        NotificationCenter.default.addObserver(self, selector: #selector(handleButtonPressed), name: .didPressDateButton, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.layoutIfNeeded()
        
    }
    
    
    private func changeLabel(toTimeStamp timeStamp: Int, xPosition x: Double){
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp/1000))
        let dateFormatter = DateFormatter()
        switch numOfDaysBeingDisplayed {
        case 1:
            fallthrough
        case 7:
            dateFormatter.dateFormat = "MMM d, hh:mm a"
        case 30:
            fallthrough
        case 90:
            fallthrough
        case 180:
            fallthrough
        case 365:
            dateFormatter.dateFormat = "MMM d, yyyy"
        default:
            break
        }
        let timeString = dateFormatter.string(from: date)
        dateLabel.text = timeString
        let intrinsicWidth = dateLabel.intrinsicContentSize.width/2
        var xTransform = CGFloat(x) * (CGFloat(view.frame.width)/CGFloat(prices.count)) - intrinsicWidth
        print(intrinsicWidth)
        print(xTransform)
        if (xTransform < 8) {
            xTransform = CGFloat(8)
        }
        let totalWidth = CGFloat(prices.count) * (CGFloat(view.frame.width)/CGFloat(prices.count))
        if (xTransform + dateLabel.intrinsicContentSize.width > totalWidth){
            xTransform = totalWidth - dateLabel.intrinsicContentSize.width - 8
        }
        dateLabel.transform = CGAffineTransform(translationX: xTransform, y: 0)
    }
    
    @objc private func handleButtonPressed(notification: Notification){
        let label = (notification.userInfo as! [String: String]).first!.value
        switch(label){
        case "1D":
            numOfDaysBeingDisplayed = 1
        case "1W":
            numOfDaysBeingDisplayed = 7
        case "1M":
            numOfDaysBeingDisplayed = 30
        case "3M":
            numOfDaysBeingDisplayed = 90
        case "6M":
            numOfDaysBeingDisplayed = 180
        case "1Y":
            numOfDaysBeingDisplayed = 365
        default:
            numOfDaysBeingDisplayed = 1
        }
        
        makeNetworkCalls(days: numOfDaysBeingDisplayed)
    }
    
    private func setupFloatingLabel(){
        view.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: view.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
    
    
    private func makeNetworkCalls(days numOfDays: Int){
        priceDictionary = [Double : Int]()
        prices = [Double]()
        
        self.setupLineChartView()
        lineChartView.addIndicator()
        NetworkManager.shared.getHistoricalData(for: cryptoID ?? "", lengthInDays: numOfDays) { (result) in
            
            switch result {
            case .success(let historicalData):
                for index in (0..<historicalData.prices.count) {
                    switch numOfDays {

                    case 90:
                        if index.isMultiple(of: 4){
                            fallthrough
                        }
                    case 30:
                        if index.isMultiple(of: 2){
                            fallthrough
                        }
                    default:
                        
                        self.priceDictionary[historicalData.prices[index].price] = historicalData.prices[index].time
                        self.prices.append(historicalData.prices[index].price)
                    }
                }

                DispatchQueue.main.async{
                    self.lineChartView.animate(xAxisDuration: 1, easingOption: .easeInSine)
                    self.setChart(values: self.prices)
                    self.calculatePercentChange(prices: self.prices)
                    self.delegate?.amountLabelShouldChange(value: self.prices.last!)
                    self.delegate?.animateLabels()
                    self.lineChartView.removeIndicator()
                }
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    private func calculatePercentChange(prices: [Double]){
        guard prices.count > 1 else { return }
        
        let startPrice = prices.first!
        let endPrice = prices.last!
        
        let percentage = endPrice / startPrice * 100
        let calculatedPercentage = percentage > 100 ? percentage - 100 : -(100 - percentage)
        
        delegate?.calculatedPercentChange(value: calculatedPercentage)
    }
    
    private func setupLineChartView(){
        view.addSubview(lineChartView)
        lineChartView.noDataText = ""
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.delegate = self
        NSLayoutConstraint.activate([
            lineChartView.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
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
        delegate?.amountLabelShouldChange(value: entry.y)
        guard let timestamp = priceDictionary[entry.y] else { return }
        changeLabel(toTimeStamp: timestamp, xPosition: highlight.x)
        guard prices.count > 1 else { return }
        calculatePercentChange(prices:  [prices.first!, entry.y])
    }
    
    func chartViewDidEndPanning(_ chartView: ChartViewBase) {
        calculatePercentChange(prices: prices)
        chartView.highlightValue(nil)
        dateLabel.text = ""
        guard prices.count > 1 else { return }
        delegate?.amountLabelShouldChange(value: prices.last!)
    }
}


