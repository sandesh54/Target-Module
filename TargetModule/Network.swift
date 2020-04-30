//
//  Network.swift
//  TargetModule
//
//  Created by Sandesh on 28/03/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import Foundation

struct Network {
    enum EndPoints: String {
        case getTeamwiseAssignedTargets = "getTeamwiseAssignedTargets"
        case getQueryPlanedTargetView = "getQueryPlanedTargetView"
        case getUserIdWiseAssignedTargets = "getUserIdWiseAssignedTargets"
        case getUserForTargetAssignment = "getUserForTargetAssignment"
        case addUpdateSalesTarget = "addUpdateSalesTarget"
        case getUserForTargetAssignmentNotifier = "getUserForTargetAssignmentNotifier"
    }
    private static let api = "http://103.93.16.230:8880/manager_webservices_v2/rest/skygge/"
    
    static func fetchDataFor( _ endpoint: EndPoints,parameters: [String: String],_ completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) {
        guard let url = URL(string: api+endpoint.rawValue) else { fatalError("invalid url for \(endpoint.rawValue)") }
        print(url.absoluteString)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = parameters.percentEncoded()
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { data, response, error in
            completionHandler(data, response, error)
        }.resume()
    }
}



