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
    var managerYearlyTarget: [YearlyTarget]!
    var managerAssignmetReport: [AllocatedVSAssignedTarget]!
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var managerTargetsInfoTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         
        guard managerOption != nil else {
            fatalError("Forgot set manager option")
        }
        
        if managerOption == .YearlyTargets && managerYearlyTarget == nil {
            fatalError("forgot to set manager yearly target")
        }
        
        if managerOption == .AllocatedvsAssignedTargets && managerAssignmetReport == nil {
            fatalError("forgot to set manager assignment report")
        }
    }
    
    private func configureTable() {
        managerTargetsInfoTable.dataSource = self
        managerTargetsInfoTable.delegate = self
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
            cell.textLabel?.text = managerYearlyTarget[indexPath.row].month
            cell.detailTextLabel?.text = managerYearlyTarget[indexPath.row].target ?? ""
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
}

extension ManagerTargetDetailVC: UITableViewDelegate {
    
}
