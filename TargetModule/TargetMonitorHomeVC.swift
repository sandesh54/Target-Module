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
    
    private let datePickerTag = 564
    private let quarterPickerTag = 565
    private var teamMember: [SalesRep] = [SalesRep(user_id: "1", person_name: "Akshay", assigned_to_type: "2")]
    private var selectedTeamMember: SalesRep?
    
    private let quarters = ["Quarter 1", "Quarter 2", "Quarter 3", "Quarter 4", "Full Year"]
    private var years: [Int] = []
    
    private var selectedQuarter = 4 {
           didSet {
               quarterSelectionButton.setTitle(quarters[selectedQuarter], for: .normal)
           }
       }
    
    private lazy var datePicker: UIPickerView  = {
        let datePicker = UIPickerView()
        datePicker.delegate = self
        datePicker.dataSource = self
        datePicker.tag = datePickerTag
        return datePicker
    }()
    
    
    private lazy var quarterPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.tag = quarterPickerTag
        return picker
    }()
    
    
    //MARK:- IBOutlets
    @IBOutlet private weak var yearSelectionButton: UIButton!
    @IBOutlet private weak var quarterSelectionButton: UIButton!
    @IBOutlet private weak var pieChart: PieChartView!
    @IBOutlet private weak var barChart: CombinedChartView!
    @IBOutlet private weak var detailViewSwitch: UISwitch!
    @IBOutlet private weak var salesRepTableView: UITableView!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupPieChartView()
        setupCombineChartView()
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
    
    
    private func setupCombineChartView() {
        barChart.rightAxis.enabled = false
        barChart.xAxis.labelPosition = .bottom
        barChart.pinchZoomEnabled = true
        barChart.doubleTapToZoomEnabled = true
        barChart.dragXEnabled = true
        barChart.xAxis.valueFormatter = XAxisNameFormater()
        barChart.leftAxis.valueFormatter = YAxisNameFormater()
        barChart.xAxis.granularity = 1
        barChart.xAxis.granularityEnabled = true
        barChart.xAxis.drawGridLinesEnabled = false
    }
    
    
    
    //MARK:- Private Methods
    
    private func setupPickerButtons() {
        let stringYear = getCurrentYear()
        yearSelectionButton.setTitle(stringYear, for: .normal)
        selectedQuarter = 4
    }
    
    private func setYearsData() {
        let stringDate = getCurrentYear()
        guard let date = Int(stringDate) else { fatalError("String date is not Int convertable") }
        years = Array(date-5 ... date+100)
        print(years)
    }
    
    private func getCurrentYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: Date())
    }
    
   
    private func setChart(_ dataPoints: [String], values: [Double]) {
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
    
    //MARK:- IBAction
    @IBAction func selectYear(_ sender: UIButton) {
        let actionSheetPicker = UIAlertController(title: "Select Year", message: nil, preferredStyle: .actionSheet)
        
        let picker = datePicker
        let stringYear = getCurrentYear()
        guard let year = Int(stringYear) else { fatalError("Year value cannot be converted to Int ")}
        let rowIndex = years.firstIndex(of: year)!
        picker.selectRow( rowIndex, inComponent: 0, animated: true)
        actionSheetPicker.view.addSubview(picker)
        actionSheetPicker.view.clipsToBounds = true
        picker.frame =  CGRect(x: 0, y: 32, width: actionSheetPicker.view.frame.width + 16, height: 100)
        actionSheetPicker.view.translatesAutoresizingMaskIntoConstraints = false
        actionSheetPicker.view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        actionSheetPicker.addAction(okAction)
        
        present(actionSheetPicker,animated:  true)
    }
    
    @IBAction func selctQuarter(_ sender: UIButton) {
        let actionSheetPicker = UIAlertController(title: "Select Quarter", message: nil, preferredStyle: .actionSheet)
        
        let picker = quarterPicker
        picker.selectRow(selectedQuarter, inComponent: 0, animated: true)
        actionSheetPicker.view.addSubview(picker)
        actionSheetPicker.view.clipsToBounds = true
        picker.frame =  CGRect(x: 0, y: 32, width: actionSheetPicker.view.frame.width + 16, height: 100)
        actionSheetPicker.view.translatesAutoresizingMaskIntoConstraints = false
        actionSheetPicker.view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        actionSheetPicker.addAction(okAction)
        
        present(actionSheetPicker,animated:  true)
    }
    
    
    //MARK:- Overriden methods
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


// MARK:- UIPICKERVIEW_DATASOURCE
extension TargetMonitorHomeVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == quarterPickerTag {
            return quarters.count
        } else if pickerView.tag == datePickerTag {
            return years.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        if pickerView.tag == quarterPickerTag {
            label.text = quarters[row]
        } else if pickerView.tag == datePickerTag {
            label.text = "\(years[row])"
        }
        return label
    }
}


//MARK:- UIPICKERVIEW_DELEGATE
extension TargetMonitorHomeVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == quarterPickerTag {
            selectedQuarter = row
        } else if pickerView.tag == datePickerTag {
            yearSelectionButton.setTitle("\(years[row])", for: .normal)
        }
    }
}
