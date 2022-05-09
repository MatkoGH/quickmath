//
//  Quiz.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-09.
//

import Foundation
import PencilKit

// MARK: - Quiz

class Quiz: ObservableObject {
    
    /// The quiz's configuration.
    @Published var configuration: Configuration
    
    /// The generated questions for the quiz.
    private(set) var questions: [Question]
    
    /// The current question.
    @Published var currentQuestion: Question
    
    /// The current state of the quiz.
    @Published var state: QuizState = .notStarted
    
    /// The amount of time taken, in seconds, since the start of the quiz.
    @Published private(set) var timeTaken: TimeInterval = 0.0
    
    /// The timer for the quiz.
    private var timer: Timer?
    
    // MARK: Computed
    
    /// Computed current question's index.
    var currentQuestionIndex: Int {
        questions.firstIndex(where: { currentQuestion.id == $0.id }) ?? 0
    }
    
    /// Computed percentage ratio between correctly-answered and answered questions.
    var correctPercentage: Int? {
        let answeredQuestions = questions.filter { $0.answerState != nil }
        let correctQuestions = answeredQuestions.filter { $0.isCorrect() }
        
        if answeredQuestions.isEmpty { return nil }
        
        let rawPercentage = (Double(correctQuestions.count) / Double(answeredQuestions.count)) * 100.0
        return Int(round(rawPercentage))
    }
    
    /// An array of skipped questions.
    var skippedQuestions: [Question] {
        questions.filter { $0.answerState == .skipped }
    }
    
    // MARK: Initializer
    
    /// Create a quiz.
    /// - Parameter configuration: The configuration to use for the quiz.
    init(using configuration: Configuration) {
        precondition(configuration.numberOfEquations > 0)
        self.configuration = configuration
        
        self.questions = Self.generateEquations(using: configuration)
            .map { equation in Question(with: equation, timeToSolve: configuration.solveTime) }
        self.currentQuestion = questions.first!
    }
    
    // MARK: Static Methods
    
    /// Generate equations for the quiz.
    /// - Parameter configuration: The quiz configuration to use for generating math equations.
    /// - Returns: An array of math equations.
    private static func generateEquations(using configuration: Configuration) -> [MathEquation] {
        MathEquation.generate(amount: configuration.numberOfEquations, using: configuration.generatorSettings)
    }
    
    // MARK: Methods
    
    /// Start the quiz.
    func start() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.timeTaken += 1.0
        }
        
        state = .running
    }
    
    /// Restart the quiz.
    func restart() {
        currentQuestion = questions.first!
        timeTaken = 0
        
        questions.forEach { question in
            question.reset(timerAsWell: true)
        }
                
        state = .notStarted
    }
    
    /// End the quiz.
    func end() {
        timer?.invalidate()
        state = .ended
    }
    
    /// Moves onto the next question.
    func nextQuestion() {
        guard state == .running else { return }
        
        guard currentQuestionIndex + 1 < questions.count else {
            end()
            return
        }
        
        currentQuestion = questions[currentQuestionIndex + 1]
    }
    
    /// Updates the quiz according to the updated configuration.
    func configurationUpdated() {
        self.questions = Self.generateEquations(using: configuration)
            .map { equation in Question(with: equation, timeToSolve: configuration.solveTime) }
        self.currentQuestion = questions.first!
        self.restart()
    }
}

// MARK: - State

extension Quiz {
    
    /// The state of a quiz.
    enum QuizState {
        
        /// The quiz has not started yet.
        case notStarted
        
        /// The quiz is currently running.
        case running
    
        /// The quiz has ended.
        case ended
    }
}
