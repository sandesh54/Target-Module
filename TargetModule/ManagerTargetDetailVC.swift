//
//  ManagerTargetDetailVC.swift
//  TargetModule
//
//  Created by Sandesh on 24/03/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import UIKit

class ManagerTargetDetailVC: UIViewController {
    
    enum ManagerOptions {
        case YearlyTargets
        case AllocatedvsAssignedTargets
    }
    
    //MARK:- PROPERTIES
    private let yearlyReportCellIdenfier = "YearlyReportCell"
    
    var managerOption: ManagerOptions!
    var selectedYear: String?
    var selectedQuarter: Int?
    
    var managerYearlyTarget: [MyTargets] = [] {
        didSet {
            if managerYearlyTarget.count > 0 {
                managerTargetsInfoTable.reloadData()
            }
        }
    }
    var managerAssignmetReport: [AllocatedVSAssignedTarget] = [] {
        didSet {
            if managerAssignmetReport.count > 0 {
                managerTargetsInfoTable.reloadData()
            }
        }
    }
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var managerTargetsInfoTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard managerOption != nil else {
            fatalError("Forgot to set manager option")
        }
        
        if managerOption == .YearlyTargets { fetchYearlyTargets() }
        if managerOption == .AllocatedvsAssignedTargets{
            guard selectedYear != nil, selectedQuarter != nil else {
                fatalError("Forgot to set selected year and quarter")
            }
            fetchAssignedVsAllocatedTargets()
        }
    }
    
    private func fetchYearlyTargets() {
        #warning("hardcoded paramenters")
        let parameters = [
            "userrole" : "2",
            "userid" : "1",
            "target_typeid" : "1",
            "yearval" : "2020",
            "frommonth" : "4",
            "tomonth" : "4"
        ]
        
        Network.fetchDataFor(.getQueryPlanedTargetView, parameters: parameters) { data, response, error in
            
            if error == nil {
                if data != nil {
                    if let result = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                        if let resCode = result["resCode"] as? String, resCode == "0" {
                            if let yearlyTargetJSON = result["resData"] as? [[String:String]] {
                                print(yearlyTargetJSON)
                                if let yearlyTargetJSONData = try? JSONSerialization.data(withJSONObject: yearlyTargetJSON, options: .fragmentsAllowed) {
                                    let decoder = JSONDecoder()
                                    guard let targets = try? decoder.decode([MyTargets].self, from: yearlyTargetJSONData) else {
                                        fatalError("unable to covert data to MYTargets")
                                    }
                                    DispatchQueue.main.async {
                                        self.managerYearlyTarget = targets
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
    
    private func fetchAssignedVsAllocatedTargets() {
        #warning("hardcoded paramenters")
        let quarterRanger = Calendar.getMonthsFor(quarter: selectedQuarter!)

        let parameters = [
            "userrole" : "2",
            "userid" : "11",
            "target_typeid" : "1",
            "yearval" : "2020",
            "frommonth" : "1",
            "tomonth" : "12"
        ]
        
        Network.fetchDataFor(.getUserIdWiseAssignedTargets,parameters: parameters) { data, response, error in
            if error == nil {
                if data != nil {
                    if let result = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                        if let resCode = result["resCode"] as? String, resCode == "0" {
                            if let allocatedVsAssignedTargetJSON = result["resData"] as? [[String:String]] {
                                print(allocatedVsAssignedTargetJSON)
                                if let allocatedVsAssignedTargetData = try? JSONSerialization.data(withJSONObject: allocatedVsAssignedTargetJSON, options: .fragmentsAllowed) {
                                    let decoder = JSONDecoder()
                                    guard let targets = try? decoder.decode([AllocatedVSAssignedTarget].self, from: allocatedVsAssignedTargetData) else {
                                        fatalError("unable to covert data to AllocatedVSAssignedTarget")
                                    }
                                    DispatchQueue.main.async {
                                        self.managerAssignmetReport = targets
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
    
    private func configureTable() {
        managerTargetsInfoTable.dataSource = self
        managerTargetsInfoTable.delegate = self
        managerTargetsInfoTable.rowHeight = UITableView.automaticDimension
        
    }
}

extension ManagerTargetDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch  managerOption {
        case .AllocatedvsAssignedTargets:
            return managerAssignmetReport.count
        case .YearlyTargets:
            return managerYearlyTarget.count
        case .none:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch managerOption {
        case .AllocatedvsAssignedTargets:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TargetAssignedVsAllocatedCell.IDENTIFIER) as? TargetAssignedVsAllocatedCell else {
                fatalError("Unable to fetch TargetAssignedVsAllocatedCell for table")
            }
            cell.loadCell(info: managerAssignmetReport[indexPath.row])
            return cell
        case .YearlyTargets:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: yearlyReportCellIdenfier) else {
                fatalError("Unable to fetch YearlyReportCell for table")
            }
            cell.textLabel?.text = managerYearlyTarget[indexPath.row].assigned_month.monthString()
            cell.detailTextLabel?.text = managerYearlyTarget[indexPath.row].assigned_target_val
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
}

extension ManagerTargetDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
