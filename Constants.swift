//
//  Constants.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-17.
//

import SwiftUI

struct K {
    
    /// The app pen color.
    static let penColor: Color = .gray
    
    /// The app fill color.
    static let fillColor: Color = Color(uiColor: .init { $0.userInterfaceStyle == .dark ? .tertiarySystemFill : .systemBackground })
    
    /// The app large rounded font.
    static let largeRoundedFont: Font = .system(size: 64, design: .rounded)
}
