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
    @IBOutlet private weak var barChartView: BarChartView!
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
        let title = ["Achived", "Pending"]
        let target:[Double] = [23000, 27000]
        pieChartView.drawHoleEnabled = false
        pieChartView.rotationEnabled = false
        pieChartView.highlightPerTapEnabled = false
        pieChartView.entryLabelColor = .red
        setupPieChart(title, values: target)
        pieChartView.animate(xAxisDuration: 1)
    }
    
    private func setUpBarChartView() {
        
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.valueFormatter = XAxisNameFormater()
        barChartView.xAxis.granularity = 1
        
        let title = ["Achived", "Pending"]
        let target:[Double] = [23000, 27000]
        setupBarChart(title, values: target)
    }
    
    private func updateView() {
        if currentView == .PieChart {
            UIView.animate(withDuration: 2) {
                self.pieCharViewLeadingConstraint.constant = 0
                self.pieChartViewTrailingConstraint.constant = 0
                
                self.barCharViewLeadingConstraint.constant = self.view.frame.width
                self.barCharViewTrailingConstraint.constant = self.view.frame.width
                
                self.view.setNeedsDisplay()
            }
        } else {
            UIView.animate(withDuration: 2) {
                self.pieCharViewLeadingConstraint.constant -= -self.view.frame.width
                self.pieChartViewTrailingConstraint.constant -= -self.view.frame.width
                
                self.barCharViewLeadingConstraint.constant = 0
                self.barCharViewTrailingConstraint.constant = 0
                self.view.setNeedsDisplay()
            }
        }
    }
    
    //MARK: PIE CHART SETUP
    
    private func setupPieChart(_ dataPoints: [String], values: [Double]) {
        var dataEntries = [PieChartDataEntry]()
        
        for pointIndex in 0 ..< dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[pointIndex], label: dataPoints[pointIndex])
            dataEntries.append(dataEntry)
        }
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "Pie")
        pieChartView.data = PieChartData(dataSet: pieChartDataSet)
        pieChartDataSet.colors = [.red,.green]
    }
    
    //MARK: BAR CHART SETUP
    private func setupBarChart(_ dataPoints: [String], values: [Double]) {
        
        let entry1 = BarChartDataEntry(x: 1, y:20)
        let entry2 = BarChartDataEntry(x: 1, y:10)
        let entry3 = BarChartDataEntry(x: 3, yValues: [25,27])
        
                
        let barChartSet1 = BarChartDataSet(entries: [entry1,entry2,entry3])
        barChartSet1.stackLabels = ["Assigned","Acheived"]
        barChartSet1.barShadowColor = .darkGray
        barChartSet1.colors = [.red,UIColor.green.withAlphaComponent(0.1)]
        barChartSet1.label = "Months"
        let data = BarChartData(dataSets: [barChartSet1])
        
        
        barChartView.data = data
        
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
