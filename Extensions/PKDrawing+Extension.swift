//
//  PKDrawing+Extension.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-13.
//

import PencilKit

/// The MNIST classifier object.
let classifier = try? MNISTClassifier(configuration: .init())

extension PKDrawing {
    
    /// Creates an array of images for each stroke within the drawing.
    /// - Returns: An array of images for each stroke.
    private func createImages() -> [UIImage] {
        var allStrokes = strokes.sortedByPosition()
        
        var strokes = allStrokes.map { stroke -> [PKStroke] in
            guard allStrokes.contains(where: { $0.renderBounds == stroke.renderBounds }) else {
                return []
            }
            
            let strokesInRange = allStrokes.strokesWithinRange(of: stroke)
            strokesInRange.forEach { inRange in
                allStrokes.removeAll(where: { $0.renderBounds == inRange.renderBounds })
            }
            
            return strokesInRange
        }
        
        strokes.removeAll(where: { $0.isEmpty })
        
        let images: [UIImage] = strokes.map { strokesInRange in
            let bounds = strokesInRange.getFullRenderBounds()
            let maxSize = Swift.max(bounds.width, bounds.height)
            
            let image = self.image(from: bounds, scale: UIScreen.main.scale)
                .asSquare()
                .withInsets(insets: .init(allEdges: maxSize / 8))
                .withTintColor(tintColor: .white)
                .withBackground(color: .black)
            
            return image
        }
        
        return images
    }
    
    /// Thickens the current drawing's strokes to allow for thin drawings.
    /// - Returns: The new thickened drawing.
    private func thickenStrokes() -> PKDrawing {
        var newStrokes: [PKStroke] = []
        
        for stroke in strokes {
            var newPoints: [PKStrokePoint] = []
            
            stroke.path.forEach { point in
                newPoints.append(
                    .init(location: point.location, timeOffset: point.timeOffset, size: CGSize(width: 10, height: 10), opacity: CGFloat(1), force: point.force, azimuth: point.azimuth, altitude: point.altitude))
            }
            
            let newPath = PKStrokePath(controlPoints: newPoints, creationDate: .now)
            newStrokes.append(.init(ink: .init(.pen, color: UIColor.white), path: newPath))
        }
        
        return .init(strokes: newStrokes)
    }
    
    /// Predicts a number from the active drawing.
    /// - Returns: An optional integer prediction.
    public func predictNumber() -> Int? {
        guard let classifier = classifier else {
            fatalError("Unable to instantiate MNIST classifier.")
        }
        
        let thickenedDrawing = thickenStrokes()
        
        let images = thickenedDrawing.createImages()
        var predictionString = ""
        
        for image in images {
            if let predicted = thickenedDrawing.predictNumberFrom(image: image, using: classifier) {
                predictionString += "\(predicted)"
            }
        }
        
        guard let finalPrediction = Int(predictionString) else {
            print("*** PREDICTION_ERROR: Failed to convert string \(predictionString) to type Int.")
            return nil
        }
        
        return finalPrediction
    }
    
    /// Predicts a number from an image using a MNIST classifier.
    /// - Parameters:
    ///   - image: The image to predict a number from.
    ///   - classifier: The MNIST classifer to use.
    /// - Returns: An optional single-digit integer prediction.
    private func predictNumberFrom(image: UIImage, using classifier: MNISTClassifier) -> Int? {
        guard let resizedImage = image.resizeImageTo(size: .init(width: 28, height: 28)) else {
            print("*** PREDICTION_ERROR: Failed to resize image from \(image.size.width)x\(image.size.height) to 28x28.")
            return nil
        }
        
        guard let pixelBuffer = resizedImage.pixelBuffer() else {
            print("*** PREDICTION_ERROR: Failed to convert UIImage to CVPixelBuffer.")
            return nil
        }
        
        do {
            let output = try classifier.prediction(image: pixelBuffer)
            return Int(output.classLabel)
        } catch {
            print("*** PREDICTION_ERROR: \(error)")
            return nil
        }
    }
}
