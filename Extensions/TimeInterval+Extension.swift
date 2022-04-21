//
//  TimeInterval+Extension.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-17.
//

import SwiftUI

extension TimeInterval {
    
    func toTimeString() -> String {
        let minutes = Int(floor(self / 60))
        let seconds = Int(self.truncatingRemainder(dividingBy: 60))
        
        return "\(minutes):\(seconds < 10 ? "0\(seconds)" : "\(seconds)")"
    }
}
