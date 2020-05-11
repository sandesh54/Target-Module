//
//  TargetMonitorHomeVC.swift
//  TargetModule
//
//  Created by Sandesh on 05/05/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import UIKit
import Charts
class TargetMonitorHomeVC: UIViewController {
    
    private var teamMember: [SalesRep] = [SalesRep(user_id: "1", person_name: "Akshay", assigned_to_type: "2")]
    private var selectedTeamMember: SalesRep?
    
    @IBOutlet private weak var yearSelectionButton: UIButton!
    @IBOutlet private weak var quarterSelectionButton: UIButton!
    @IBOutlet private weak var pieChart: PieChartView!
    @IBOutlet private weak var barChart: BarChartView!
    @IBOutlet private weak var detailViewSwitch: UISwitch!
    @IBOutlet private weak var salesRepTableView: UITableView!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
       
    }
    
    //MARK: - Subview setup
    private func setupTableView() {
        salesRepTableView.dataSource = self
        salesRepTableView.delegate = self
        salesRepTableView.reloadData()
        salesRepTableView.tableFooterView = UIView()
    }
    
    private func setupPieChartView() {
        let months = ["Achived", "Pending"]
        let unitsSold:[Double] = [23000, 27000]
        pieChart.drawHoleEnabled = true
        pieChart.rotationEnabled = false
        pieChart.highlightPerTapEnabled = false
        pieChart.entryLabelColor = .red
        setChart(months, values: unitsSold)
        pieChart.animate(xAxisDuration: 1)
    }
    
    private func setupBarChartView() {
        
    }
    
    
    func setChart(_ dataPoints: [String], values: [Double]) {
        
        var dataEntries: [PieChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i])
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "Total: 50000")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChart.data = pieChartData
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TeamMemberTargetsDetailVC {
            destination.teamMember = selectedTeamMember
        }
    }
}

extension TargetMonitorHomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamMember.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SalesRepCell", for: indexPath)
        cell.textLabel?.text = teamMember[indexPath.row].person_name
        return cell
    }
    
    
}


extension TargetMonitorHomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedTeamMember = teamMember[indexPath.row]
        performSegue(withIdentifier: "showDetails", sender: self)
    }
}
