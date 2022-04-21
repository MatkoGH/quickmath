//
//  Int+Extension.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-20.
//

import Foundation
import SwiftUI

extension Int {
    
    func toString(minimumNumberCount: Int = 1) -> String {
        let minimumNumberCount = minimumNumberCount > 0 ? minimumNumberCount : 1
        
        let selfAsString = String(self)
        let selfNumberCount = selfAsString.count
        
        let difference = minimumNumberCount - selfNumberCount
        let zeroes = difference > 1 ? String(repeating: "0", count: difference) : ""
        
        return zeroes + selfAsString
    }
}
