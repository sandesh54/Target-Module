//
//  SalesRepTargetDetailCell.swift
//  TargetModule
//
//  Created by Sandesh on 26/03/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import UIKit

class SalesRepTargetDetailCell: UITableViewCell {

    @IBOutlet private weak var monthLabel: UILabel!
    @IBOutlet private weak var assigenedTargetLabel: UILabel!
    @IBOutlet private weak var achievedTargetLabel: UILabel!
    
    @IBOutlet private weak var newTargetTextField: UITextField!
    @IBOutlet private weak var saveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func loadCell(_ target: SalesRepTargets) {
        monthLabel.text = ": \(target.assigned_month)"
        assigenedTargetLabel.text = ": \(target.assigned_target_val)"
    }
}
