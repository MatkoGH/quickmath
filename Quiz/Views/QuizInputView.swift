//
//  QuizInputView.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-18.
//

import SwiftUI
import PencilKit

struct QuizInputView: View {
    
    @ObservedObject var question: Quiz.Question
    @State var color: Color = .gray
    
    let classifier = try? MNISTClassifier(configuration: .init())
    
    var body: some View {
        DrawingView(canvasView: $question.canvasView) { drawing in
            predictNumber(from: drawing)
        }
        .colorMultiply(color)
        .animation(.linear(duration: 0.1), value: color)
        .onChange(of: question.answerState) { newValue in
            if case .answered(let isCorrect) = newValue {
                color = isCorrect ? .green : .red
            } else {
                color = .gray
            }
        }
    }
    
    func predictNumber(from drawing: PKDrawing) {
        let number = drawing.predictNumber()
        question.answer(number: number)
    }
}
