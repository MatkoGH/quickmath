//
//  DrawingView.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-10.
//

import SwiftUI
import PencilKit

// MARK: - DrawingView

struct DrawingView: UIViewRepresentable {
    
    @Binding var canvasView: PKCanvasView
    
    var onSaved: (PKDrawing) -> Void
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.tool = PKInkingTool(ink: .init(.pen, color: .white), width: 16)
        canvasView.delegate = context.coordinator
        canvasView.drawingPolicy = .anyInput
        
        canvasView.backgroundColor = .clear
        
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
            self.runOnSavedIfNecessary(drawing: canvasView.drawing)
        }
        
        func removeUnnecessaryStrokes(from canvasView: PKCanvasView) {
            let minSize = min(canvasView.frame.width, canvasView.frame.height) / 20.0
            
            canvasView.drawing.strokes.enumerated().forEach { (index, stroke) in
                if max(stroke.renderBounds.width, stroke.renderBounds.height) < minSize {
                    parent.canvasView.drawing.strokes.remove(at: index)
                }
            }
        }
        
        func runOnSavedIfNecessary(drawing: PKDrawing) {
            if !drawing.strokes.isEmpty {
                parent.onSaved(drawing)
            }
        }
    }
}
