//
//  Extensions.swift
//  TargetModule
//
//  Created by Sandesh on 28/03/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import Foundation


extension String {
    func monthString() -> String {
        switch self {
        case "1": return "January"
        case "2": return "February"
        case "3": return "March"
        case "4": return "April"
        case "5": return "May"
        case "6": return "June"
        case "7": return "July"
        case "8": return "August"
        case "9": return "September"
        case "10": return "October"
        case "11": return "November"
        case "12": return "December"
        default: return ""
        }
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

