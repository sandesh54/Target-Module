//
//  AssignedTarget.swift
//  TargetModule
//
//  Created by Sandesh on 23/03/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import Foundation

struct AssignedTarget: Codable {
    var month: String
    var year: String
    var salesrep_id: String
    var salesrep_name: String
    var assignedTarget: String?
}
