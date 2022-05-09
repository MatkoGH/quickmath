//
//  Quiz+Question.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-19.
//

import SwiftUI
import PencilKit

// MARK: - Question

extension Quiz {
    
    /// A quiz question answer number.
    typealias AnswerNumber = Int
    
    /// A quiz question structure.
    class Question: Equatable, Identifiable, ObservableObject {
        
        /// A unique identifier for this question.
        let id = UUID().uuidString
        
        /// The math equation.
        let equation: MathEquation
        
        /// The amount of time given to solve this question.
        let timeToSolve: TimeInterval?
        
        /// Canvas view for the question's drawing input.
        @Published var canvasView: PKCanvasView = .init()
        
        /// The user's answer to the question.
        @Published private(set) var answer: AnswerNumber? = nil
        
        /// The answer state of the question.
        @Published private(set) var answerState: AnswerState? = nil
        
        /// The time left to answer the equation.
        @Published private(set) var timeLeft: TimeInterval?
        
        /// The timer for the question.
        private var timer: Timer?
        
        // MARK: Computed
        
        /// The answer to the equation.
        var equationAnswer: Int {
            equation.answer
        }
        
        // MARK: Methods
        
        /// Sets the current answer state.
        /// - Parameter number: The number to set the current answer to.
        func answer(number: Int?) {
            guard number != nil, answerState == nil else {
                answer = number != nil ? answer : nil
                answerState = number != nil ? answerState : nil
                return
            }
            
            answer = number
            checkCurrentAnswer()
        }
        
        /// Sets the current answer state to skipped.
        func skip() {
            answerState = .skipped
            timer?.invalidate()
        }
        
        /// Checks if the current answer is correct. Sets answer state.
        func checkCurrentAnswer(timeRanOut: Bool = false) {
            answerState = isCorrect() ? .correct : (timeRanOut ? .incorrect : nil)
            
            if answerState?.isCorrect != nil {
                timer?.invalidate()
            }
        }
        
        /// Start the question's timer.
        func startTimer() {
            guard timeLeft != nil else { return }

            timer?.invalidate()
            timer = .scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                if self.timeLeft! <= 0 {
                    withAnimation(.defaultSpring) { self.checkCurrentAnswer(timeRanOut: true) }
                    self.timer?.invalidate()
                    return
                }
                
                self.timeLeft! -= 1
            }
        }
        
        /// Resets the question.
        /// - Parameter timerAsWell: Boolean indicating whether to reset the timer as well.
        func reset(timerAsWell: Bool = false) {
            if timerAsWell {
                timer?.invalidate()
                timeLeft = timeToSolve
            }
            
            clearDrawing()
            answer(number: nil)
        }
        
        /// Checks whether answer is correct.
        /// - Returns: Boolean indicating whether the answer is correct.
        func isCorrect() -> Bool {
            answer == equationAnswer
        }
        
        /// Checks whether the question has been answered.
        /// - Returns: Boolean indicating whether the question has been answered.
        func hasAnswered() -> Bool {
            answerState != nil
        }
        
        /// Clear the question's canvas.
        func clearDrawing() {
            canvasView.drawing = .init()
        }
        
        /// Create a quiz question.
        /// - Parameter equation: The question's equation.
        init(with equation: MathEquation, timeToSolve: TimeInterval? = nil) {
            self.equation = equation
            self.timeToSolve = timeToSolve
            self.timeLeft = timeToSolve
        }
        
        /// Equivalent function. Checks ID's.
        static func == (lhs: Question, rhs: Question) -> Bool {
            lhs.id == rhs.id
        }
    }
    
    /// Enum containing correct and incorrect values.
    enum AnswerState {
        
        /// The answer is correct.
        case correct
        
        /// The answer is incorrect.
        case incorrect
        
        /// The question was skipped.
        case skipped
    
        /// Optional boolean indicating whether the answer is correct.
        var isCorrect: Bool? {
            switch self {
            case .correct:
                return true
            case .incorrect:
                return false
            default:
                return nil
            }
        }
    }
}
