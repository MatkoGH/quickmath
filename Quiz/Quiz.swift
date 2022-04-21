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
    let configuration: Configuration
    
    /// The generated questions for the quiz.
    private(set) var questions: [Question]
    
    /// The current state of the quiz.
    @Published var state: QuizState = .notStarted
    
    /// The current question.
    @Published var currentQuestion: Question
    
    /// The amount of time taken, in seconds, since the start of the quiz.
    @Published private(set) var timeTaken: TimeInterval = 0.0
    
    /// The timer for the quiz.
    private var timer: Timer?
    
    /// The current question's computed index.
    var currentQuestionIndex: Int {
        questions.firstIndex(where: { currentQuestion.id == $0.id }) ?? 0
    }
    
    /// Computed percentage ratio between correctly-answered and answered questions.
    var correctPercentage: Int? {
        let answeredQuestions = questions.filter { $0.answerState.isAnswered }
        let correctQuestions = answeredQuestions.filter { $0.answerState.isCorrect }
        
        if answeredQuestions.isEmpty {
            return nil
        }
        
        let rawRatio = Double(correctQuestions.count / answeredQuestions.count)
        return Int(round(rawRatio * 100))
    }
    
    // MARK: Initializer
    
    /// Create a quiz.
    /// - Parameter configuration: The configuration to use for the quiz.
    init(using configuration: Configuration) {
        precondition(configuration.amountOfEquations > 0)
        self.configuration = configuration
        
        self.questions = Self.generateEquations(using: configuration)
            .map { equation in Question(with: equation) }
        self.currentQuestion = questions.first!
    }
    
    // MARK: Static Methods
    
    /// Generate equations for the quiz.
    /// - Parameter configuration: The quiz configuration to use for generating math equations.
    /// - Returns: An array of math equations.
    private static func generateEquations(using configuration: Configuration) -> [MathEquation] {
        MathEquation.generate(amount: configuration.amountOfEquations, using: configuration.generatorSettings)
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
        timeTaken = 0
        currentQuestion = questions.first!
        start()
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

// MARK: - Settings

extension Quiz {
    
    /// A configuration structure for quizzes.
    struct Configuration {
        
        /// The total amount of equations to include in the quiz.
        var amountOfEquations: Int
        
        /// The amount of time given to solve each question.
        var solveTime: Int
        
        /// The settings to use for generating equations.
        var generatorSettings: MathEquation.GeneratorSettings
    }
}
