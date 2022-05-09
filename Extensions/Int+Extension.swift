//
//  Int+Extension.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-20.
//

import Foundation
import SwiftUI

extension Int {
    
    /// Converts the integer into a string, with an optional minumum number count.
    /// If there are not enough numbers, there will be zeroes added to the front of the number.
    /// - Parameter minimumNumberCount: The optional minimum amount of numbers to have in the string.
    /// - Returns: A string of the integer with the minimum numebr count.
    func toString(minimumNumberCount: Int = 1) -> String {
        let minimumNumberCount = minimumNumberCount > 0 ? minimumNumberCount : 1
        
        let selfAsString = String(self)
        let selfNumberCount = selfAsString.count
        
        let difference = minimumNumberCount - selfNumberCount
        let zeroes = difference > 0 ? String(repeating: "0", count: difference) : ""
        
        return zeroes + selfAsString
    }
}
