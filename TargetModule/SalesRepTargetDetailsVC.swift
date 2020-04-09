//
//  SalesRepTargetDetailsVC.swift
//  TargetModule
//
//  Created by Sandesh on 26/03/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import UIKit

class SalesRepTargetDetailsVC: UIViewController {
    
    var salesRep: SalesRep?
    var selectedYear: String?
    var selectedQuarter: Int?
    
    private var salesRepTargets: [SalesRepTargets] = [] {
        didSet {
            if salesRepTargets.count > 0 { salesRepDetailsTable.reloadData()}
        }
    }
    
    @IBOutlet private weak var salesRepDetailsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTable()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard salesRep != nil  else {
            fatalError("Forgot to set salesRep")
        }
        guard selectedYear != nil, selectedQuarter != nil else {
            fatalError("Forgot to set selected year and quarter")
        }
        fetchSalesRepTargetDetails()
    }
    
    
    func fetchSalesRepTargetDetails() {
        #warning("hardcoded paramenters")
        let quarterRanger = Calendar.getMonthsFor(quarter: selectedQuarter!)
        let parameters = [
            "userrole" : "2",
            "userid" : "1",
            "target_typeid" : "1",
            "yearval" : "2020",
            "frommonth" : "4",
            "tomonth" : "6"
        ]
        
        Network.fetchDataFor(.getTeamwiseAssignedTargets,parameters: parameters) { data, response, error in
            if error == nil {
                if data != nil {
                    if let result = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                        if let resCode = result["resCode"] as? String, resCode == "0" {
                            if let salesRepTargetJSON = result["resData"] as? [[String:String]] {
                                print(salesRepTargetJSON)
                                if let salesRepTargetData = try? JSONSerialization.data(withJSONObject: salesRepTargetJSON, options: .fragmentsAllowed) {
                                    let decoder = JSONDecoder()
                                    guard let targets = try? decoder.decode([SalesRepTargets].self, from: salesRepTargetData) else {
                                        fatalError("unable to covert data to AllocatedVSAssignedTarget")
                                    }
                                    DispatchQueue.main.async {
                                        self.salesRepTargets = targets
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
        salesRepDetailsTable.tableFooterView = UIView()
        salesRepDetailsTable.dataSource = self
        salesRepDetailsTable.delegate = self
        salesRepDetailsTable.rowHeight = UITableView.automaticDimension
    }
}


extension SalesRepTargetDetailsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        salesRepTargets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "salesRepDetailCell") as? SalesRepTargetDetailCell {
            cell.loadCell(salesRepTargets[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    
}

extension SalesRepTargetDetailsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
