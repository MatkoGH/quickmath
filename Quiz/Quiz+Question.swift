//
//  Quiz+Question.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-19.
//

import Foundation
import PencilKit

// MARK: - Question

extension Quiz {
    
    /// A quiz question structure.
    class Question: Equatable, Identifiable, ObservableObject {
        
        /// A unique identifier for this question.
        let id = UUID().uuidString
        
        /// The math equation.
        let equation: MathEquation
        
        /// Canvas view for the question's drawing input.
        @Published var canvasView: PKCanvasView = .init()
        
        /// The answer state of the question.
        @Published private(set) var answerState: AnswerState = .answering(nil)
        
        /// The time left to answer the equation.
        @Published private(set) var timeLeft: TimeInterval = 1.0
        
        /// The answer to the equation.
        var equationAnswer: Int {
            equation.answer
        }
        
        func startTimer() {
            
        }
        
        /// Sets the current answer state.
        /// - Parameter number: The number to set the current answer to.
        func answer(number: Int?) {
            answerState = .answering(number)
            checkCurrentAnswer()
        }
        
        /// Checks if the current answer is correct. Sets answer state.
        func checkCurrentAnswer(timeRanOut: Bool = false) {
            if case .answering(let number) = answerState, let number = number, (number == equationAnswer || timeRanOut) {
                self.answerState = .answered(number == equationAnswer)
            }
        }
        
        /// Resets the canvas' drawing.
        func clearAnswer() {
            canvasView.drawing = .init()
            answerState = .answering(nil)
        }
        
        /// Create a quiz question.
        /// - Parameter equation: The question's equation.
        init(with equation: MathEquation) {
            self.equation = equation
        }
        
        /// Equivalent function. Checks ID's.
        static func == (lhs: Question, rhs: Question) -> Bool {
            lhs.id == rhs.id
        }
    }
    
    /// The answering state of a question.
    enum AnswerState: Equatable {
        
        /// Currently answering. With an optional value.
        case answering(Int?)
        
        /// Has answered. With a boolean indicating whether the answer is correct.
        case answered(Bool)
        
        /// Skipped the question.
        case skipped
        
        /// Computed boolean indicating whether the question has been answered.
        var isAnswered: Bool {
            self == .answered(true) || self == .answered(false)
        }
        
        /// Computed boolean indicating whether the answer is correct.
        var isCorrect: Bool {
            self == .answered(true)
        }
    }
}
