//
//  TargetAssignedVsAllocatedCell.swift
//  TargetModule
//
//  Created by Sandesh on 24/03/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import UIKit

class TargetAssignedVsAllocatedCell: UITableViewCell {
    
    static let IDENTIFIER = "AssignmentReportCell"
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var myAssignedTargetLabel: UILabel!
    @IBOutlet weak var allotedByMeLabel: UILabel!
    @IBOutlet weak var pendingAllocationLabel: UILabel!
    @IBOutlet weak var baseView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func loadCell( info: AllocatedVSAssignedTarget) {
        monthLabel.text = "\(info.assigned_month)/\(info.assigned_year)"
        myAssignedTargetLabel.text = ": \(info.assigned_target_val)"
        allotedByMeLabel.text = ": \(info.allocated_target_val)"
        pendingAllocationLabel.text = ": \(info.pending_target_val)"
    }

}
