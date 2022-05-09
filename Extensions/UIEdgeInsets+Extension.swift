//
//  UIEdgeInsets+Extension.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-12.
//

import UIKit

extension UIEdgeInsets {
    
    /// Creates an EdgeInsets object with the same inset on every edge.
    /// - Parameter insets: The inset to use for every edge.
    init(allEdges insets: CGFloat) {
        self.init(top: insets, left: insets, bottom: insets, right: insets)
    }
}
