//
//  View+Extension.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-18.
//

import SwiftUI

extension View {
    
    func fillContainer() -> some View {
        modifier(FillContainerModifier())
    }
    
    func padding(style: PaddingModifier.Style = .default) -> some View {
        modifier(PaddingModifier(style: style))
    }
    
    func roundBackground(color: Color) -> some View {
        modifier(ColorRoundBackgroundModifier(color: color))
    }
    
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
    
    var color: Color
    
    func body(content: Content) -> some View {
        content.background(color, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

struct MaterialRoundBackgroundModifier: ViewModifier {
    
    var material: Material
    
    func body(content: Content) -> some View {
        content.background(material, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
