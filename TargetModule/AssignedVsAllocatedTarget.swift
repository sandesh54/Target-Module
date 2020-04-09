//
//  AssignedVsAllocatedTarget.swift
//  TargetModule
//
//  Created by Sandesh on 23/03/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import Foundation

//["target_id": "15",
// "assigned_by": "1",
// "allocated_target_val": "--",
// "assigned_year": "2020",
// "target_type_id": "1",
// "assigned_target_val": "10000",
// "assigned_month": "4",
// "assigned_to": "11",
// "assigned_date": "2020-03-18 14:47:35.0",
// "pending_target_val": "--",
// "assigned_to_type": "1",
// "modified_date": "--"]
struct AllocatedVSAssignedTarget: Codable {
    private(set) var target_id: String
    private(set) var assigned_by: String
    private(set) var allocated_target_val: String
    private(set) var assigned_year: String
    private(set) var target_type_id: String
    private(set) var assigned_target_val: String
    private(set) var assigned_month: String
    private(set) var assigned_to: String
    private(set) var assigned_date: String
    private(set) var pending_target_val: String
    private(set) var assigned_to_type: String
    private(set) var modified_date: String
    
}
