//
//  CollectionViewCell.swift
//  TargetModule
//
//  Created by Sandesh on 02/04/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    static let IDENTIFIER = "CollectionCell"
    private var target: SalesRepTargets!
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var newTargetTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseView.layer.cornerRadius = 8
        baseView.layer.borderColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
        baseView.layer.borderWidth = 1
        
        saveButton.layer.cornerRadius = 22
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = #colorLiteral(red: 0, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
    }

    
    @IBAction private func saveNewTarget(_ sender: UIButton) {
        //targetid: 0 for insert and 1 for update
        #warning("Below paramenters needs to based on sales rep target info wherever needed. For new targer insertion some data will be blank")
        #warning("Need to test this functionlity based on new ID")
        //NOTE: TARGET TYPE ID 1 BY DEFAULT
        let parametes = [
            "targetid" : "2",
            "assign_to" : "1",
            "assign_to_type" : "1",
            "assign_month" : "4",
            "assign_year" : "2020",
            "assign_by_user" : "4",
            "assign_targetval" : "",
            "target_typeid" : ""
        ]
        
//        "resCode": "0",
//        "resMessage": "Data Inserted Successfully !",
//        "resData": {
//            "inserted_targetid": "19"
//        }
        
        Network.fetchDataFor(.addUpdateSalesTarget, parameters: parametes) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                        if let resCode = result["resCode"] as? String, resCode == "0" {
                            if let message = result["resMessage"] as? String {
                                print(message)
                            }
                        } else {
                            if let errorMessage = result["resMessage"] as? String {
                                let alert = UIAlertController(title: "Alert", message: errorMessage, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default))
                                DispatchQueue.main.async {
                                    //self.present(alert, animated:  true)
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
    func loadCell(with target: SalesRepTargets) {
        self.target = target
        monthLabel.text = ": \(target.assigned_month.monthString())"
        
    }
}
