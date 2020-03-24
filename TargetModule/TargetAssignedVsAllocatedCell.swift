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
    @IBOutlet weak var myAssignedTargetLabel: UILabel!
    @IBOutlet weak var allotedByMeLabel: UILabel!
    @IBOutlet weak var pendingAllocationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func loadCell( info: AllocatedVSAssignedTarget) {
        myAssignedTargetLabel.text = info.allocated
        allotedByMeLabel.text = info.assigned
        pendingAllocationLabel.text = info.pending
    }

}
