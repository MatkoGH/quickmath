//
//  PKStroke+Extension.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-11.
//

import PencilKit

extension PKStroke {
    
    public func isWithinHorizontalRange(to stroke: PKStroke, range: CGFloat) -> Bool {
        abs(self.renderBounds.origin.x - stroke.renderBounds.origin.x) <= range
    }
    
    public func isWithinRange(to stroke: PKStroke, rangeSize: CGSize) -> Bool {
        abs(self.renderBounds.origin.x - stroke.renderBounds.origin.x) <= rangeSize.width
        && abs(self.renderBounds.origin.y - stroke.renderBounds.origin.y) <= rangeSize.height
    }
    
    public func isWithinRange(to stroke: PKStroke, range: CGFloat) -> Bool {
        isWithinRange(to: stroke, rangeSize: .init(width: range, height: range))
    }
}

extension Array where Element == PKStroke {
    
    public func sortedByPosition() -> [PKStroke] {
        return self.sorted(by: { $0.renderBounds.origin.x < $1.renderBounds.origin.x })
    }
    
    public func getFullRenderBounds() -> CGRect {
        let (minX, maxX, minY, maxY) = (
            self.sorted(by: { $0.renderBounds.minX < $1.renderBounds.minX })[0].renderBounds.minX,
            self.sorted(by: { $0.renderBounds.maxX > $1.renderBounds.maxX })[0].renderBounds.maxX,
            self.sorted(by: { $0.renderBounds.minY < $1.renderBounds.minY })[0].renderBounds.minY,
            self.sorted(by: { $0.renderBounds.maxY > $1.renderBounds.maxY })[0].renderBounds.maxY)
        
        return .init(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
    
    public func strokesWithinRange(of stroke: PKStroke) -> [PKStroke] {
        var strokesLeft = self
        let (rangeX, rangeY) = (stroke.renderBounds.width, stroke.renderBounds.height * 1.2)
        
        return strokesLeft.filter { filterStroke in
            let isWithinRange = filterStroke.isWithinRange(to: stroke, rangeSize: .init(width: rangeX, height: rangeY))
            if let index = strokesLeft.firstIndex(where: { $0.renderBounds == filterStroke.renderBounds }) {
                strokesLeft.remove(at: index)
            }
            
            return isWithinRange
        }
    }
}
