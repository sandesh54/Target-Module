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
    private var myTargets: [MyTargets]?
    
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
    
    @IBAction func quarterSegemntChaned(_ sender: UISegmentedControl) {
        updateChartForQuarter(sender.selectedSegmentIndex)
    }
    
    //MARK: - PRIVATE METHODS
    
    private func setupSubView() {
        detailViewSwitch.isOn = false
        currentView = .PieChart
        setupPieChartView()
        setUpBarChartView()
    }
    
    private func setupPieChartView() {

        pieChartView.rotationEnabled = false
        pieChartView.highlightPerTapEnabled = false
        pieChartView.entryLabelColor = .white
        updateChartForQuarter(0)

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
        
        updateChartForQuarter(0)
        
    }
    
    private func updateView() {
        if currentView == .PieChart {
            UIView.transition(from: combineChartView, to: pieChartView, duration: 0.7, options: [.transitionFlipFromLeft,.showHideTransitionViews, .layoutSubviews])
        } else {
            UIView.transition(from: pieChartView, to: combineChartView, duration: 0.7, options: [.transitionFlipFromRight,.showHideTransitionViews,.layoutSubviews])
        }
    }
    
    private func updateChartForQuarter(_ quarter: Int) {
        var quarterTargets = [SalesRepTargets]()
        switch quarter {
        case 0:
            quarterTargets = SalesRepTargets.dummyTargets.filter { ["4","5","6"].contains($0.assigned_month) }
        case 1:
             quarterTargets = SalesRepTargets.dummyTargets.filter { ["7","8","9"].contains($0.assigned_month) }
        case 2:
             quarterTargets = SalesRepTargets.dummyTargets.filter { ["10","11","12"].contains($0.assigned_month) }
        case 3:
             quarterTargets = SalesRepTargets.dummyTargets.filter { ["1","2","3"].contains($0.assigned_month) }
        case 4:
            quarterTargets = SalesRepTargets.dummyTargets
        default: break
        }
        
        if currentView == .BarChart {
            setupCombinedChart(quarterTargets)
            combineChartView.animate(yAxisDuration: 0.7)
        } else {
            setupPieChart(quarterTargets)
            pieChartView.animate(xAxisDuration: 1)
            pieChartView.animate(yAxisDuration: 1)
        }
        
    }
    
    //MARK: PIE CHART SETUP
    #warning("assigned_target_val tobe replaced by acieved and pending")
    private func setupPieChart(_ dataPoints: [SalesRepTargets]) {
        var dataEntries = [PieChartDataEntry]()
        let assignedTarget = dataPoints.reduce(0) { $0 + (Double($1.assigned_target_val) ?? 0)}
        pieChartView.centerText = "Total \n \(assignedTarget)"
        let dataEntry1 = PieChartDataEntry(value: assignedTarget , label: "Assigned")
        let dataEntry2 = PieChartDataEntry(value: dataPoints.randomElement()!.getAchievedTarget, data: "Achived")
        dataEntries = [dataEntry1, dataEntry2]
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "Pie")
        pieChartView.data = PieChartData(dataSet: pieChartDataSet)
        pieChartDataSet.colors = [.blue,.green]
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
        lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        lineChartDataSet.drawVerticalHighlightIndicatorEnabled = false
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


