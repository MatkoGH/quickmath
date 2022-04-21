//
//  Animation+Extension.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-19.
//

import SwiftUI

extension Animation {
    
    static let defaultSpring: Self = .spring(response: 0.4, dampingFraction: 0.9)
}

extension AnyTransition {
    
    static let moveAcross: Self = .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
}
