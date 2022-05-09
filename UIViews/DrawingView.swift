//
//  DrawingView.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-10.
//

import SwiftUI
import PencilKit

// MARK: - DrawingView

/// A UIViewRepresentable that has a PencilKit canvas, which does not have its own SwiftUI view.
struct DrawingView: UIViewRepresentable {
    
    /// The canvas view to display.
    @Binding var canvasView: PKCanvasView
    
    /// A handler to call upon a change in the canvas view's drawing.
    var onChanged: (PKDrawing) -> Void
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.tool = PKInkingTool(.pen, color: UIColor(.white), width: 16)
        canvasView.delegate = context.coordinator
        canvasView.drawingPolicy = .anyInput
        
        // Pen color is broken in dark mode, so make it light.
        canvasView.overrideUserInterfaceStyle = .light
        
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        
        return canvasView
    }
    
    func updateUIView(_ canvasView: PKCanvasView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        .init(for: self)
    }
}

// MARK: - Coordinator

extension DrawingView {
    
    class Coordinator: NSObject, PKCanvasViewDelegate {
    
        private var parent: DrawingView
        
        init(for parent: DrawingView) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            self.removeUnnecessaryStrokes(from: canvasView)
            self.runOnChangedIfNecessary(drawing: canvasView.drawing)
        }
        
        func removeUnnecessaryStrokes(from canvasView: PKCanvasView) {
            let minSize = min(canvasView.frame.width, canvasView.frame.height) / 20.0
            
            canvasView.drawing.strokes.enumerated().forEach { (index, stroke) in
                if max(stroke.renderBounds.width, stroke.renderBounds.height) < minSize {
                    parent.canvasView.drawing.strokes.remove(at: index)
                }
            }
        }
        
        func runOnChangedIfNecessary(drawing: PKDrawing) {
            if !drawing.strokes.isEmpty {
                parent.onChanged(drawing)
            }
        }
    }
}
