//
//  TimeInterval+Extension.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-17.
//

import SwiftUI

extension TimeInterval {
    
    /// Converts the time interval to a string with the provided style.
    /// - Parameter style: The style to set the time interval to. Defaults to default.
    /// - Returns: The string from the time interval.
    func toString(style: StringType = .default) -> String {
        let minutes = Int(floor(self / 60))
        let seconds = Int(self.truncatingRemainder(dividingBy: 60))
        
        switch style {
        case .default:
            return "\(minutes):\(seconds.toString(minimumNumberCount: 2))"
        case .suffixed:
            return "\(minutes > 0 ? "\(minutes) min " : "")\(seconds > 0 ? "\(seconds) sec" : "")"
        }
    }
    
    enum StringType {
        case `default`
        case suffixed
    }
}
