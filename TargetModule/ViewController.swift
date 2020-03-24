//
//  ViewController.swift
//  TargetModule
//
//  Created by Sandesh on 23/03/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - PROPERTIES
    private let datePickerTag = 564
    private let quarterPickerTag = 565
    private let managetOptionTableViewTag = 878
    private let salesRepTableViewTag = 879
    private let managerCellIdentifier = "ManagerOptionCell"
    private let salesRepTargeCell = "SalesRepTargetCell"
    private let quarters = ["Quarter 1", "Quarter 2", "Quarter 3", "Quarter 4", "Full Year"]
    private var selectedQuarter = 4 {
        didSet {
            quarterPickerButton.setTitle(quarters[selectedQuarter], for: .normal)
        }
    }
    
    private let managerOptions = ["My allocated Targets", "Target allocated vs Target Assigned"]
    private var salesReps = [String]()
    
    lazy var datePicker: UIDatePicker  = {
        let datePicker = UIDatePicker()
        datePicker.minimumDate = Date()
        datePicker.date = Date()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        datePicker.tag = datePickerTag
        return datePicker
    }()
    
    
    lazy var quarterPicker: UIPickerView = {
        let picker = UIPickerView(frame: CGRect(x: 16, y: 8, width: 200, height: 300))
        picker.delegate = self
        picker.dataSource = self
        picker.tag = quarterPickerTag
        return picker
    }()
    
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var yearPickerButton: UIButton!
    @IBOutlet weak var quarterPickerButton: UIButton!
    
    @IBOutlet weak var managerOptionsTableView: UITableView!
    @IBOutlet weak var salesRepTableView: UITableView!
    
    
    
    //MARK:- LIFE CYCLES
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTables()
    }
    
    //MARK: - IBACTIONS
    @IBAction func selectYear(_ sender: UIButton) {
        let actionSheetPicker = UIAlertController(title: "Select Year", message: nil, preferredStyle: .actionSheet)
        
        let picker = datePicker
        actionSheetPicker.view.addSubview(picker)
        actionSheetPicker.view.clipsToBounds = true
        picker.frame =  CGRect(x: 0, y: 32, width: actionSheetPicker.view.frame.width + 16, height: 200)
        actionSheetPicker.view.translatesAutoresizingMaskIntoConstraints = false
        actionSheetPicker.view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        actionSheetPicker.addAction(okAction)
    
        present(actionSheetPicker,animated:  true)
    }
    
    @IBAction func selctQuarter(_ sender: UIButton) {
        let actionSheetPicker = UIAlertController(title: "Select Quarter", message: nil, preferredStyle: .actionSheet)
        
        let picker = quarterPicker
        actionSheetPicker.view.addSubview(picker)
        actionSheetPicker.view.clipsToBounds = true
        picker.frame =  CGRect(x: 0, y: 32, width: actionSheetPicker.view.frame.width + 16, height: 100)
        actionSheetPicker.view.translatesAutoresizingMaskIntoConstraints = false
        actionSheetPicker.view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        actionSheetPicker.addAction(okAction)
        
        present(actionSheetPicker,animated:  true)
    }
    
    //MARK:- METHODS
    @objc func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let stringDate = dateFormatter.string(from: sender.date)
        yearPickerButton.setTitle(stringDate, for: .normal)
    }
    
    
    //MARK:- METHODS
     private func configureTables() {
         managerOptionsTableView.dataSource = self
         managerOptionsTableView.delegate = self
        managerOptionsTableView.tag = managetOptionTableViewTag
         
         salesRepTableView.delegate = self
         salesRepTableView.dataSource = self
        salesRepTableView.tag = salesRepTableViewTag
        
        managerOptionsTableView.reloadData()
        salesRepTableView.reloadData()
     }
}

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return quarters.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.text = quarters[row]
        return label
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == quarterPickerTag {
            selectedQuarter = row
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == managetOptionTableViewTag {
            return managerOptions.count
        } else if tableView.tag == salesRepTableViewTag {
            return salesReps.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == managetOptionTableViewTag {
            let cell = tableView.dequeueReusableCell(withIdentifier: managerCellIdentifier)!
            cell.textLabel?.text = managerOptions[indexPath.row]
            return cell
        } else if tableView.tag ==  salesRepTableViewTag {
            let cell = tableView.dequeueReusableCell(withIdentifier: salesRepTargeCell)!
            cell.textLabel?.text = salesReps[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
    }
    
    
}


extension ViewController: UITableViewDelegate {
    
}
