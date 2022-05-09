//
//  QuizInputView.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-18.
//

import SwiftUI
import PencilKit

/// A quiz's input view. Can either be a keyboard or a drawing canvas.
struct QuizInputView: View {
    
    /// The active quiz question.
    @ObservedObject var question: Quiz.Question
    
    /// Color of the drawing canvas's strokes.
    @State var color: Color = K.penColor
    
    /// The MNIST number classifer.
    let classifier = try? MNISTClassifier(configuration: .init())
    
    var body: some View {
        DrawingView(canvasView: $question.canvasView) { drawing in
            predictNumber(from: drawing)
        }
        .colorMultiply(color)
        .animation(.linear(duration: 0.1), value: color)
        .onChange(of: question.answerState) { newValue in
            switch newValue {
            case .correct: color = .green
            case .incorrect: color = .red
            case .skipped: color = .orange
            default: color = .gray
            }
        }
    }
    
    /// Attempts to predict a number from a PencilKit drawing.
    func predictNumber(from drawing: PKDrawing) {
        let number = drawing.predictNumber()
        question.answer(number: number)
    }
}
