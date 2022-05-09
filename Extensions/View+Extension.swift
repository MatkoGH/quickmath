//
//  View+Extension.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-18.
//

import SwiftUI

extension View {
    
    /// Fills the container view.
    func fillContainer() -> some View {
        modifier(FillContainerModifier())
    }
    
    /// Adds a style of padding to the view.
    /// - Parameter style: The padding style to add.
    func padding(style: PaddingModifier.Style = .default) -> some View {
        modifier(PaddingModifier(style: style))
    }
    
    /// Adds a round background to the view with a provided color.
    /// - Parameter color: The color to set the round background to.
    func roundBackground(color: Color) -> some View {
        modifier(ColorRoundBackgroundModifier(color: color))
    }
    
    /// Adds a round background to the view with a provided material.
    /// - Parameter material: The material to set the round background to.
    func roundBackground(material: Material) -> some View {
        modifier(MaterialRoundBackgroundModifier(material: material))
    }
}

struct FillContainerModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PaddingModifier: ViewModifier {
    
    /// The padding style.
    var style: Style
    
    func body(content: Content) -> some View {
        switch style {
        case .default:
            return content.padding(.horizontal, 16).padding(.vertical, 12)
        case .small:
            return content.padding(.horizontal, 12).padding(.vertical, 8)
        case .large:
            return content.padding(.horizontal, 20).padding(.vertical, 16)
        }
    }
    
    enum Style {
        case `default`, small, large
    }
}

struct ColorRoundBackgroundModifier: ViewModifier {
    
    /// The color.
    var color: Color
    
    func body(content: Content) -> some View {
        content.background(color, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

struct MaterialRoundBackgroundModifier: ViewModifier {
    
    /// The material.
    var material: Material
    
    func body(content: Content) -> some View {
        content.background(material, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
