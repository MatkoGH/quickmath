//
//  UIEdgeInsets+Extension.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-12.
//

import UIKit

extension UIEdgeInsets {
    
    init(allEdges insets: CGFloat) {
        self.init(top: insets, left: insets, bottom: insets, right: insets)
    }
}
