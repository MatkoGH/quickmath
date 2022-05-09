//
//  Color+Extension.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-20.
//

import SwiftUI

extension Color {
    
    /// Get a color based on a provided percentage.
    /// - Parameter percentage: The percentage.
    /// - Returns: The color based on the percentage.
    static func percentageColor(for percentage: Int?) -> Self {
        guard let percentage = percentage else {
            return .gray
        }

        switch percentage {
        case 0...33:
            return .red
        case 34...66:
            return .orange
        case 67...100:
            return .green
        default:
            return .gray
        }
    }
}
