//
//  Quiz+Configuration.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-23.
//

import SwiftUI

// MARK: - Configuration

extension Quiz {
    
    /// The default quiz configuration.
    static let defaultConfiguration: Configuration = .default
    
    /// A configuration structure for quizzes.
    struct Configuration: Equatable, Codable {
        
        /// The number of equations to include in the quiz.
        var numberOfEquations: Int
        
        /// The optional amount of time given to solve each question.
        var solveTime: TimeInterval
        
        /// The lowest number to use in an equation.
        var lowestNumber: Int
        
        /// The highest number to use in an equation.
        var highestNumber: Int
        
        /// An array of operations for the generator to use.
        var operations: [MathOperation]
        
        // MARK: Computed
        
        /// An array of the operations that are not being used.
        var unusedOperations: [MathOperation] {
            MathOperation.all.filter {
                !operations.contains($0)
            }
        }
        
        /// The settings to use for generating equations.
        var generatorSettings: MathEquation.GeneratorSettings {
            .init(lowestNumber: lowestNumber, highestNumber: highestNumber, operations: operations)
        }
        
        // MARK: Initializer
        
        /// Create a configuration structure for a quiz.
        /// - Parameters:
        ///   - settings: The math equation generator settings to use for equation generation.
        ///   - amountOfEquations: The amount of equations to generate.
        ///   - solveTime: The optional amount of time to solve each question.
        init(amountOfEquations: Int, solveTime: TimeInterval, numberRange: Range<Int>, operations: [MathOperation]) {
            self.numberOfEquations = amountOfEquations
            self.solveTime = solveTime
            
            self.lowestNumber = numberRange.lowerBound
            self.highestNumber = numberRange.upperBound
            
            self.operations = operations
        }
        
        // MARK: Static
        
        /// The default quiz configuration.
        static let `default`: Configuration = .init(
            amountOfEquations: 10,
            solveTime: 15,
            numberRange: 1..<10,
            operations: MathOperation.all
        )
        
        /// The number range to use.
        static let numberRange: Range<Int> = .init(1...30)
        
        /// The pre-set solve times.
        static let solveTimes: [TimeInterval] = [3, 5, 10, 15, 20, 25, 30, 45, 60, 90, 120, 180, 240, 300, 600]
        
        /// Equatable protocol stub.
        static func == (lhs: Quiz.Configuration, rhs: Quiz.Configuration) -> Bool {
            lhs.numberOfEquations == rhs.numberOfEquations
            && lhs.solveTime == rhs.solveTime
            && lhs.lowestNumber == rhs.lowestNumber
            && lhs.highestNumber == rhs.highestNumber
            && lhs.operations == rhs.operations
        }
        
        // MARK: Methods
        
        /// Toggles an operation.
        mutating func toggleOperation(_ operation: MathOperation) {
            if let index = operations.firstIndex(of: operation) {
                guard operations.count > 1 else { return }
                operations.remove(at: index)
            } else {
                operations.append(operation)
                operations.sort()
            }
        }
    }
}
