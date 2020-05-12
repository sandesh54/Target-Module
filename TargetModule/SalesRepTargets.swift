//
//  AssignedTarget.swift
//  TargetModule
//
//  Created by Sandesh on 23/03/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import Foundation
//"target_id": "15",
//"assigned_to": "11",
//"assigned_to_type": "1",
//"assigned_month": "4",
//"assigned_year": "2020",
//"assigned_by": "1",
//"assigned_target_val": "10000",
//"target_type_id": "1",
//"assigned_date": "2020-03-18 14:47:35.0"

struct SalesRepTargets: Codable {
    private(set) var assigned_date: String
    private(set) var target_type_id: String
    private(set) var target_id: String
    private(set) var assigned_year: String
    private(set) var assigned_to_type: String
    private(set) var assigned_by: String
    private(set) var assigned_to: String
    private(set) var assigned_month: String
    private(set) var assigned_target_val: String
    
    
    var getAssignedTarget: Double {
        if let target = Double(assigned_target_val) { return target}
        else { return 0 }
    }
    
    var getAchievedTarget: Double {
        let val = Array(10000 ... 50000).randomElement()!
        return Double(val)
    }
}



extension SalesRepTargets {
    static func getNewEmptyTarget(for year: Int, quarter: Int, salesRep: SalesRep) -> [SalesRepTargets] {
        switch quarter {
        case 0:
            return [
                generateNewTarger(for: "\(year)", month: "4", salesRep: salesRep),
                generateNewTarger(for: "\(year)", month: "5", salesRep: salesRep),
                generateNewTarger(for: "\(year)", month: "6", salesRep: salesRep)
            ]
        case 1:
            return [
                generateNewTarger(for: "\(year)", month: "7", salesRep: salesRep),
                generateNewTarger(for: "\(year)", month: "8", salesRep: salesRep),
                generateNewTarger(for: "\(year)", month: "9", salesRep: salesRep)
            ]
        case 2:
            return [
                generateNewTarger(for: "\(year)", month: "10", salesRep: salesRep),
                generateNewTarger(for: "\(year)", month: "11", salesRep: salesRep),
                generateNewTarger(for: "\(year)", month: "12", salesRep: salesRep)
            ]
        case 3:
            return [
                generateNewTarger(for: "\(year+1)", month: "1", salesRep: salesRep),
                generateNewTarger(for: "\(year+1)", month: "2", salesRep: salesRep),
                generateNewTarger(for: "\(year+1)", month: "3", salesRep: salesRep)
            ]
        case 4:
            
            return [
                generateNewTarger(for: "\(year)", month: "4", salesRep: salesRep),
                generateNewTarger(for: "\(year)", month: "5", salesRep: salesRep),
                generateNewTarger(for: "\(year)", month: "6", salesRep: salesRep),
                
                generateNewTarger(for: "\(year)", month: "7", salesRep: salesRep),
                generateNewTarger(for: "\(year)", month: "8", salesRep: salesRep),
                generateNewTarger(for: "\(year)", month: "9", salesRep: salesRep),
                
                generateNewTarger(for: "\(year)", month: "10", salesRep: salesRep),
                generateNewTarger(for: "\(year)", month: "11", salesRep: salesRep),
                generateNewTarger(for: "\(year)", month: "12", salesRep: salesRep),
                
                generateNewTarger(for: "\(year+1)", month: "1", salesRep: salesRep),
                generateNewTarger(for: "\(year+1)", month: "2", salesRep: salesRep),
                generateNewTarger(for: "\(year+1)", month: "3", salesRep: salesRep)
            ]
        default :break
        }
        return []
    }
    
    
    private static func generateNewTarger(for year: String, month: String, salesRep: SalesRep) -> SalesRepTargets{
        #warning("assigned to type not known, assigned by needs tobe added based on whos logged in.")
        return SalesRepTargets(assigned_date: "",
                               target_type_id: "1",
                               target_id: "",
                               assigned_year: year,
                               assigned_to_type:"",
                               assigned_by: "",
                               assigned_to: "\(salesRep.user_id)",
                               assigned_month: month,
                               assigned_target_val: "")
    }
    
    static let dummyTargets = [
        SalesRepTargets(assigned_date: "", target_type_id: "", target_id: "", assigned_year: "", assigned_to_type: "", assigned_by: "", assigned_to: "", assigned_month: "1", assigned_target_val: "23344"),
        SalesRepTargets(assigned_date: "", target_type_id: "", target_id: "", assigned_year: "", assigned_to_type: "", assigned_by: "", assigned_to: "", assigned_month: "2", assigned_target_val: "22344"),
        SalesRepTargets(assigned_date: "", target_type_id: "", target_id: "", assigned_year: "", assigned_to_type: "", assigned_by: "", assigned_to: "", assigned_month: "3", assigned_target_val: "43565"),
        SalesRepTargets(assigned_date: "", target_type_id: "", target_id: "", assigned_year: "", assigned_to_type: "", assigned_by: "", assigned_to: "", assigned_month: "4", assigned_target_val: "74545"),
        SalesRepTargets(assigned_date: "", target_type_id: "", target_id: "", assigned_year: "", assigned_to_type: "", assigned_by: "", assigned_to: "", assigned_month: "5", assigned_target_val: "34566"),
        SalesRepTargets(assigned_date: "", target_type_id: "", target_id: "", assigned_year: "", assigned_to_type: "", assigned_by: "", assigned_to: "", assigned_month: "6", assigned_target_val: "48564"),
        SalesRepTargets(assigned_date: "", target_type_id: "", target_id: "", assigned_year: "", assigned_to_type: "", assigned_by: "", assigned_to: "", assigned_month: "7", assigned_target_val: "65474"),
        SalesRepTargets(assigned_date: "", target_type_id: "", target_id: "", assigned_year: "", assigned_to_type: "", assigned_by: "", assigned_to: "", assigned_month: "8", assigned_target_val: "34367"),
        SalesRepTargets(assigned_date: "", target_type_id: "", target_id: "", assigned_year: "", assigned_to_type: "", assigned_by: "", assigned_to: "", assigned_month: "9", assigned_target_val: "23555"),
        SalesRepTargets(assigned_date: "", target_type_id: "", target_id: "", assigned_year: "", assigned_to_type: "", assigned_by: "", assigned_to: "", assigned_month: "10", assigned_target_val: "76856"),
        SalesRepTargets(assigned_date: "", target_type_id: "", target_id: "", assigned_year: "", assigned_to_type: "", assigned_by: "", assigned_to: "", assigned_month: "11", assigned_target_val: "67655"),
        SalesRepTargets(assigned_date: "", target_type_id: "", target_id: "", assigned_year: "", assigned_to_type: "", assigned_by: "", assigned_to: "", assigned_month: "12", assigned_target_val: "53534"),
    ]
    
}
