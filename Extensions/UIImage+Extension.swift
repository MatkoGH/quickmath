//
//  UIImage+Extension.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-11.
//

import UIKit

extension UIImage {
    
    /// Resizes an image to a provided size.
    /// - Parameter size: The CGSize to resize the image to.
    /// - Returns: An optional resized image.
    public func resizeImageTo(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
    /// Converts the image to a CVPixelBuffer.
    /// - Returns: An optional CVPixelBuffer.
    public func pixelBuffer() -> CVPixelBuffer? {
        let attributes = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue,
        ] as CFDictionary
        
        var pixelBuffer: CVPixelBuffer?
        
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            Int(self.size.width),
            Int(self.size.height),
            kCVPixelFormatType_OneComponent8,
            attributes,
            &pixelBuffer)
        
        guard status == kCVReturnSuccess else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        
        let context = CGContext(
            data: pixelData,
            width: Int(self.size.width),
            height: Int(self.size.height),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!),
            space: colorSpace,
            bitmapInfo: 0)
        
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        self.draw(in: .init(x: 0, y: 0, width: self.size.width, height: self.size.height))
        UIGraphicsPopContext()
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
    
    /// Converts the current image to a square by adding horizontal or vertical padding.
    /// - Returns: An optional square image.
    public func asSquare() -> UIImage {
        if size.width == size.height {
            return self
        }
        
        let (minSize, maxSize) = (min(size.width, size.height), max(size.width, size.height))
        let sizeToUse = (maxSize - minSize) / 2
        let isHorizontal = size.width < size.height
        
        UIGraphicsBeginImageContextWithOptions(.init(width: maxSize, height: maxSize), false, self.scale)
        defer { UIGraphicsEndImageContext() }
        
        let _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: isHorizontal ? sizeToUse : 0, y: !isHorizontal ? sizeToUse : 0)
        
        self.draw(at: origin)
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
    
    /// Adds padding to the edge of an image.
    /// - Parameter insets: The insets to add to each edge.
    /// - Returns: The padded image.
    public func withInsets(insets: UIEdgeInsets) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(.init(width: self.size.width + insets.left + insets.right, height: self.size.height + insets.top + insets.bottom), false, self.scale)
        defer { UIGraphicsEndImageContext() }
        
        let _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        
        self.draw(at: origin)
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
    
    /// Tints the image to the provided color.
    /// - Parameter tintColor: The color to tint the image to.
    /// - Returns: The tinted image.
    public func withTintColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else { return self }
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1, y: -1)
        context.setBlendMode(.normal)

        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.clip(to: rect, mask: self.cgImage!)
        tintColor.setFill()
        context.fill(rect)

        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
    
    /// Adds a colored background to the image.
    /// - Parameters:
    ///   - color: The color to set the background to.
    ///   - opaque: Boolean indicating whether the background should be opaque. Defaults to true.
    /// - Returns: The image with the background.
    public func withBackground(color: UIColor, opaque: Bool = true) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        
        guard let ctx = UIGraphicsGetCurrentContext(), let image = cgImage else { return self }
        defer { UIGraphicsEndImageContext() }
        
        let rect = CGRect(origin: .zero, size: size)
        ctx.setFillColor(color.cgColor)
        ctx.fill(rect)
        ctx.concatenate(.init(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height))
        ctx.draw(image, in: rect)
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}
