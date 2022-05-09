//
//  EnvironmentValues+Namespace.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-21.
//

import SwiftUI

/// Namespace environment key.
struct NamespaceEnvironmentKey: EnvironmentKey {
    
    static var defaultValue: Namespace.ID = Namespace().wrappedValue
}

extension EnvironmentValues {
    
    /// Namespace environment value.
    var namespace: Namespace.ID {
        get { self[NamespaceEnvironmentKey.self] }
        set { self[NamespaceEnvironmentKey.self] = newValue }
    }
}

extension View {
    
    /// Pass a namespace into the environment.
    /// - Parameter value: Namespace to pass into the environment.
    func namespace(_ value: Namespace.ID) -> some View {
        environment(\.namespace, value)
    }
}
