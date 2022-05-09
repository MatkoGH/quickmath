//
//  Animation+Extension.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-19.
//

import SwiftUI

extension Animation {
    
    /// Default spring animation.
    static let defaultSpring: Self = .spring(response: 0.4, dampingFraction: 0.9)
}

extension AnyTransition {
    
    /// Default move across transition.
    static let moveAcross: Self = .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)).combined(with: .opacity)
}
