//
//  Calander+Extension.swift
//  TargetModule
//
//  Created by Sandesh on 02/04/20.
//  Copyright © 2020 Sandesh. All rights reserved.
//

import Foundation

extension Calendar {
    static func getMonthsFor( quarter: Int) -> (form: Int, to: Int) {
        switch quarter {
        case 0: return (4, 6)
        case 1: return (7, 9)
        case 2: return (10, 12)
        case 3: return (1, 3)
        case 4: return (4, 3)
        default: fatalError("Invalid quarter")
        }
    }

}
