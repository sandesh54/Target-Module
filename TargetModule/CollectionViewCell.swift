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

    func loadCell(with target: SalesRepTargets) {
        self.target = target
        monthLabel.text = ": \(target.assigned_month.monthString())"
    }
}
