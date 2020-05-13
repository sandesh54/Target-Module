//
//  ViewController.swift
//  TargetModule
//
//  Created by Sandesh on 23/03/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import UIKit

//MARK - VIEWCONTROLLER
class ViewController: UIViewController {
    
    //MARK:  PROPERTIES
    
    private let parameters = [
           "userrole" : "2",
           "userid" : "9"
       ]
    
    
    private let datePickerTag = 564
    private let quarterPickerTag = 565
    private let managetOptionTableViewTag = 878
    private let salesRepTableViewTag = 879
    private let managerCellIdentifier = "ManagerOptionCell"
    private let salesRepTargeCell = "SalesRepTargetCell"
    private let quarters = ["Quarter 1", "Quarter 2", "Quarter 3", "Quarter 4", "Full Year"]
    private var years: [Int] = []
    
    private var selectedQuarter = 4 {
        didSet {
            quarterPickerButton.setTitle(quarters[selectedQuarter], for: .normal)
        }
    }
    
    private let managerOptions = ["My allocated Targets", "Target allocated vs Target Assigned"]
    private var selectedManagerOptionRow = 0
    private var selectedSaleRepsRow = 0
    private var salesRepList:[SalesRep] = []
    
    lazy var datePicker: UIPickerView  = {
        let datePicker = UIPickerView()
        datePicker.delegate = self
        datePicker.dataSource = self
        datePicker.tag = datePickerTag
        return datePicker
    }()
    
    
    lazy var quarterPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.tag = quarterPickerTag
        return picker
    }()
    
    
    //MARK:  IBOUTLETS
    @IBOutlet weak var yearPickerButton: UIButton!
    @IBOutlet weak var quarterPickerButton: UIButton!
    
    @IBOutlet weak var managerOptionsTableView: UITableView!
    @IBOutlet weak var salesRepTableView: UITableView!
    
    
    
    //MARK: LIFE CYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTables()
        setYearsData()
        setupPickerButtons()
        fetchSalesRepTargets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        createDummyData()
    }
    
    //MARK: IBACTIONS
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
    
    
    //MARK: METHODS
    private func configureTables() {
        managerOptionsTableView.dataSource = self
        managerOptionsTableView.delegate = self
        managerOptionsTableView.tag = managetOptionTableViewTag
        
        salesRepTableView.delegate = self
        salesRepTableView.dataSource = self
        salesRepTableView.tag = salesRepTableViewTag
        salesRepTableView.register(UINib(nibName: "ExpandingCell", bundle: .main), forCellReuseIdentifier: ExpandingCell.IDENTIFIER)
        
        managerOptionsTableView.reloadData()
        salesRepTableView.reloadData()
        
        
    }
    
    private func setupPickerButtons() {
        let stringYear = getCurrentYear()
        yearPickerButton.setTitle(stringYear, for: .normal)
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
    
    private func fetchSalesRepTargets() {
        Network.fetchDataFor(.getUserForTargetAssignment, parameters: parameters) { (data, response, error) in
                if error == nil {
                if data != nil {
                    if let result = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                        if let resCode = result["resCode"] as? String, resCode == "0" {
                            if let salesRepListJSON = result["resData"] as? [[String:String]] {
                                print(salesRepListJSON)
                                if let salesRepListJSONData = try? JSONSerialization.data(withJSONObject: salesRepListJSON, options: .fragmentsAllowed) {
                                    let decoder = JSONDecoder()
                                    if let salesReps = try? decoder.decode([SalesRep].self, from: salesRepListJSONData) {
                                        self.salesRepList = []
                                        self.salesRepList = salesReps
                                        DispatchQueue.main.async {
                                            self.salesRepTableView.reloadData()
                                        }
                                    } else {
                                        fatalError("Sales rep list json conversion failed")
                                    }
                                }
                            }
                        } else {
                            if let errorMessage = result["resMessage"] as? String {
                                let alert = UIAlertController(title: "Alert", message: errorMessage, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default))
                                DispatchQueue.main.async {
                                    self.present(alert, animated:  true)
                                }
                                
                            }
                        }
                    } else {
                        print("Error: unable to serialize JSON object for salesresp data")
                    }
                } else {
                    print("No data found for getUserForTargetAssignment")
                }
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    // MARK: OVERRIDEN METHODS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ManagerTargetDetailVC {
            switch selectedManagerOptionRow {
            case 0:
                destination.managerOption = .YearlyTargets
            case 1:
                destination.managerOption = .AllocatedvsAssignedTargets
                destination.selectedYear = yearPickerButton.currentTitle
                destination.selectedQuarter = selectedQuarter
            default: return
            }
        }
        if let destination = segue.destination as? SalesRepTargetDetailsVC {
            destination.salesRep = salesRepList[selectedSaleRepsRow]
            destination.selectedYear = yearPickerButton.currentTitle
            destination.selectedQuarter = selectedQuarter
        }
    }
}

// MARK:- UIPICKERVIEW_DATASOURCE
extension ViewController: UIPickerViewDataSource {
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
extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == quarterPickerTag {
            selectedQuarter = row
        } else if pickerView.tag == datePickerTag {
            yearPickerButton.setTitle("\(years[row])", for: .normal)
        }
    }
}

// MARK: - UITABLEVIEW_DATASOURCE
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == managetOptionTableViewTag {
            return managerOptions.count
        } else if tableView.tag == salesRepTableViewTag {
            return salesRepList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == managetOptionTableViewTag {
            let cell = tableView.dequeueReusableCell(withIdentifier: managerCellIdentifier)!
            cell.textLabel?.text = managerOptions[indexPath.row]
            return cell
        } else if tableView.tag ==  salesRepTableViewTag {
//            //Basic table view cell
//            let cell = tableView.dequeueReusableCell(withIdentifier: salesRepTargeCell)!
//            cell.textLabel?.text = salesRepList[indexPath.row].person_name
//            return cell
            
           // Expanding table view cell
            let cell = tableView.dequeueReusableCell(withIdentifier: ExpandingCell.IDENTIFIER) as! ExpandingCell
            cell.loadCell(salesRep: salesRepList[indexPath.row])
            cell.dataSource = self
            cell.delegate = self
            return cell
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView.tag == salesRepTableViewTag {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 80))
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width - 44, height: 44))
            label.text = "Sales Rep Details"
            view.addSubview(label)
            let button = UIButton(frame: CGRect(x: tableView.bounds.width - 44, y: 0, width: 44, height: 44))
            button.backgroundColor = .red
            button.addTarget(self, action: #selector(notifyUsers), for: .touchUpInside)
            view.addSubview(button)
            view.backgroundColor = .white
            view.backgroundColor = .green
            return view
       }
        return nil
    }
    
    @objc private func notifyUsers(_ sender: UIButton) {
        let parameter = [
            "userrole": "2",
            "userid": "9"
        ]
        Network.fetchDataFor(.getUserForTargetAssignmentNotifier, parameters: parameter) { data, response, error in
            if error == nil, data != nil {
                print(String(data: data!, encoding: .utf8) ?? "")
            } else {
                 print(error!.localizedDescription)
            }
        }
    }
}

//MARK:- UITABLEVIEW_DELEGATE
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == managetOptionTableViewTag {
            selectedManagerOptionRow = indexPath.row
            performSegue(withIdentifier: "showMangerInfo", sender: self)
        } else if tableView.tag == salesRepTableViewTag {
//            selectedSaleRepsRow = indexPath.row
//            performSegue(withIdentifier: "salesRepTarget", sender: self)
            
            if let cell = salesRepTableView.cellForRow(at: indexPath) as? ExpandingCell {
                
                if cell.isExpanded == false {
                    for case let cell as ExpandingCell in tableView.visibleCells {
                        cell.isExpanded = false
                    }
                }
                tableView.beginUpdates()
                cell.isExpanded.toggle()
                tableView.endUpdates()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension ViewController: ExpandingCellDataSource {
    func getYearForTargets(for cell: ExpandingCell) -> String {
        return yearPickerButton.currentTitle!
    }
    
    func getQuarterForTargets(for cell: ExpandingCell) -> Int {
        return selectedQuarter
    }    
}

extension ViewController: ExpandingCellDelegate {
    func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated:  true)
    }
}
