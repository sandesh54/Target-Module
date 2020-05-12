//
//  TeamMemberTargetsDetailVC.swift
//  TargetModule
//
//  Created by Sandesh on 06/05/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import UIKit
import Charts

class TeamMemberTargetsDetailVC: UIViewController {
    private enum ChartView {
        case PieChart
        case BarChart
    }
    
    var teamMember: SalesRep?
    
    private var currentView: ChartView = .PieChart {
        didSet {
            updateView()
        }
    }

    //MARK: - IBOUTLETS
    @IBOutlet private weak var pieChartView: PieChartView!
    @IBOutlet private weak var combineChartView: CombinedChartView!
    @IBOutlet private weak var detailViewSwitch: UISwitch!
    @IBOutlet private weak var quarterPicker: UISegmentedControl!
    
    @IBOutlet private weak var pieCharViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var pieChartViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var barCharViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var barCharViewLeadingConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubView()
        
    }
    
    //MARK: - IBACTIONS
    @IBAction func swithchView(_ sender: UISwitch) {
        if sender.isOn {
            currentView = .BarChart
        } else {
            currentView = .PieChart
        }
    }
    
    //MARK: - PRIVATE METHODS
    
    private func setupSubView() {
        detailViewSwitch.isOn = false
        currentView = .PieChart
        setupPieChartView()
        setUpBarChartView()
    }
    
    private func setupPieChartView() {

        pieChartView.drawHoleEnabled = false
        pieChartView.rotationEnabled = false
        pieChartView.highlightPerTapEnabled = false
        pieChartView.entryLabelColor = .red
        
        
        setupPieChart(SalesRepTargets.dummyTargets[0])
        pieChartView.animate(xAxisDuration: 1)
    }
    
    private func setUpBarChartView() {
        combineChartView.rightAxis.enabled = false
        combineChartView.xAxis.labelPosition = .bottom
        
        combineChartView.pinchZoomEnabled = true
        combineChartView.doubleTapToZoomEnabled = true
        combineChartView.dragXEnabled = true
        combineChartView.xAxis.valueFormatter = XAxisNameFormater()
        combineChartView.leftAxis.valueFormatter = YAxisNameFormater()
        combineChartView.xAxis.granularity = 1
        combineChartView.xAxis.granularityEnabled = true

        combineChartView.xAxis.drawGridLinesEnabled = false
        
        //let target:[Double] = [23000, 27000]
        setupCombinedChart(SalesRepTargets.dummyTargets)
        combineChartView.animate(xAxisDuration: 1)
    }
    
    private func updateView() {
        if currentView == .PieChart {
            UIView.transition(from: combineChartView, to: pieChartView, duration: 0.7, options: [.transitionFlipFromLeft,.showHideTransitionViews, .layoutSubviews])
        } else {
            UIView.transition(from: pieChartView, to: combineChartView, duration: 0.7, options: [.transitionFlipFromRight,.showHideTransitionViews,.layoutSubviews])
        }
    }
    
    //MARK: PIE CHART SETUP
    
    private func setupPieChart(_ dataPoints: SalesRepTargets) {
        var dataEntries = [PieChartDataEntry]()
        
        let dataEntry1 = PieChartDataEntry(value: dataPoints.getAssignedTarget , label: "Assigned")
        let dataEntry2 = PieChartDataEntry(value: dataPoints.getAchievedTarget, data: "Achived")
        dataEntries = [dataEntry1, dataEntry2]
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "Pie")
        pieChartView.data = PieChartData(dataSet: pieChartDataSet)
        pieChartDataSet.colors = [.red,.green]
    }
    
    //MARK: BAR CHART SETUP
    private func setupCombinedChart(_ dataPoints: [SalesRepTargets]) {
        
        var lineChartEntries = [ChartDataEntry]()
        var barChartDataEntry = [BarChartDataEntry]()
        
        //creating data entry points for line and bar
        for index in 1 ... dataPoints.count {
            print(index)
            lineChartEntries.append(ChartDataEntry(x: Double(index), y: dataPoints[index-1].getAchievedTarget))
            barChartDataEntry.append(BarChartDataEntry(x: Double(index), y: dataPoints[index-1].getAssignedTarget))
        }
        
        //line chart data set
        let lineChartDataSet = LineChartDataSet(entries: lineChartEntries)
        lineChartDataSet.lineWidth = 0.0
        lineChartDataSet.cubicIntensity = 1
        lineChartDataSet.drawCirclesEnabled = true
        lineChartDataSet.drawValuesEnabled = true
        lineChartDataSet.isHorizontalHighlightIndicatorEnabled = false
        lineChartDataSet.isVerticalHighlightIndicatorEnabled = false
        lineChartDataSet.circleColors = [.green]
        
        //bar graph data set
        let barGraphDataSet = BarChartDataSet(entries: barChartDataEntry)
        barGraphDataSet.colors = [UIColor(red: 0/255, green: 128/255, blue: 128/255, alpha: 1.0)]
        
        //combined chart data
        let data = CombinedChartData()
        data.lineData = LineChartData(dataSet: lineChartDataSet)
        data.barData = BarChartData(dataSet: barGraphDataSet)
        
        combineChartView.xAxis.axisMinimum = data.lineData.xMin - 1
        combineChartView.xAxis.axisMaximum = data.lineData.xMax + 1
        combineChartView.data = data
        
    }
}

final class XAxisNameFormater: NSObject, IAxisValueFormatter {

    func stringForValue( _ value: Double, axis _: AxisBase?) -> String {
        switch value {
        case 1: return "Jan"
        case 2: return "Feb"
        case 3: return "Mar"
        case 4: return "Apr"
        case 5: return "May"
        case 6: return "June"
        case 7: return "July"
        case 8: return "Aug"
        case 9: return "Sep"
        case 10: return "Oct"
        case 11: return "Nov"
        case 12: return "Dec"
        default: return ""
            
        }
    }
}

final class YAxisNameFormater: NSObject, IAxisValueFormatter {

    func stringForValue( _ value: Double, axis _: AxisBase?) -> String {
        let val = Int(value)
        if val/1000 > 0 {
            return "\(val/1000)K"
        } else {
            return "\(val)"
        }
    }
}


