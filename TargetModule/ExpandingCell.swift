//
//  ExpandingCell.swift
//  TargetModule
//
//  Created by Sandesh on 02/04/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import UIKit

protocol ExpandingCellDataSource {
    func getYearForTargets(for cell: ExpandingCell) -> String
    func getQuarterForTargets(for cell: ExpandingCell) -> Int
 }

protocol ExpandingCellDelegate {
    func showAlert(with title: String, message: String)
}

class ExpandingCell: UITableViewCell {

    static let IDENTIFIER = "ExpandingCell"
    var isExpanded: Bool = false {
        didSet {
            if isExpanded == true, dataSource != nil {
                fetchSalesRepTargetDetails()
                collectionView.isHidden = false
                collectionViewHeight.constant = 100
            } else {
                collectionView.isHidden = true
                collectionViewHeight.constant = 0
            }
        }
    }
    
    var dataSource: ExpandingCellDataSource?
    var delegate: ExpandingCellDelegate?
    
    private var salesRepTargets = [SalesRepTargets]() {
        didSet {
            if salesRepTargets.count > 0 {
                collectionView.reloadData()
            }
        }
    }
    private var salesRep: SalesRep!
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var salesRepNameLabel: UILabel!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    
    private var flowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.itemSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.height - 16)
        return layout
    }
    override func awakeFromNib() {
        selectionStyle = .none
        super.awakeFromNib()
        collectionView.collectionViewLayout = flowLayout
        collectionView.isHidden = true
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: .main), forCellWithReuseIdentifier: CollectionViewCell.IDENTIFIER)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsSelection = false
        
        isExpanded = false
    }
    
    func loadCell(salesRep: SalesRep) {
        self.salesRep = salesRep
        salesRepNameLabel.text = salesRep.person_name
    }

    func fetchSalesRepTargetDetails() {
        #warning("hardcoded paramenters")
        let quarterRanger = Calendar.getMonthsFor(quarter: dataSource!.getQuarterForTargets(for: self))
        let parameters = [
            "userrole" : "2",
            "userid" : "1",
            "target_typeid" : "1",
            "yearval" : "2020",
            "frommonth" : "\(quarterRanger.form)",
            "tomonth" : "\(quarterRanger.to)"
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
                                        if targets.isEmpty {
                                            let year = Int(self.dataSource!.getYearForTargets(for: self))!
                                            let quarter = self.dataSource!.getQuarterForTargets(for: self)
                                            self.salesRepTargets = SalesRepTargets.getNewEmptyTarget(for: year, quarter: quarter, salesRep: self.salesRep)
                                        } else {
                                             self.salesRepTargets = targets
                                        }
                                        
                                    }
                                }
                            }
                        } else {
                            if let errorMessage = result["resMessage"] as? String {
                                let alert = UIAlertController(title: "Alert", message: errorMessage, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default))
                                DispatchQueue.main.async {
                                    self.delegate?.showAlert(with: "Alert", message: errorMessage)
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
}


extension ExpandingCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return salesRepTargets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.IDENTIFIER, for: indexPath) as! CollectionViewCell
        cell.loadCell(with: salesRepTargets[indexPath.row])
        return cell
    }
    
}

extension ExpandingCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isExpanded.toggle()
    }
}
