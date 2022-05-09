//
//  Equation.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-09.
//

import Foundation

typealias MathEquationString = String

/// An equation structure.
struct MathEquation {
    
    /// The equation string.
    let string: MathEquationString
    
    // MARK: Computed Values
    
    /// The computed equation's string using spacing and more readable symbols.
    var displayString: String {
        var str = string
        MathOperation.all.forEach {
            str = str.replacingOccurrences(of: $0.symbol, with: " \($0.displaySymbol) ")
        }
        
        return str
    }
    
    /// A computed answer value for the equation.
    var answer: Int {
        Self.solve(equation: string)
    }
    
    // MARK: Initializer
    
    /// Create an equation
    /// - Parameter string: The equation string
    init(string: String) {
        self.string = string
    }
}

// MARK: - Solver

extension MathEquation {
    
    /// A static method to solve the given equation.
    /// - Parameter equation: The equation string to solve.
    /// - Returns: The answer to the equation.
    static func solve(equation: MathEquationString) -> Int {
        let number = NSExpression(format: equation).expressionValue(with: nil, context: nil) as? NSNumber
        return number?.intValue ?? 0
    }
}

// MARK: - Generator

extension MathEquation {
    
    /// A tuple containing information about a mathematical expression.
    typealias Expression = (Int, Int, MathOperation)
    
    /// Generates an array of equations.
    /// - Parameters:
    ///   - amount: The amount of equations to generate.
    ///   - settings: The settings to use for equation generation.
    /// - Returns: The generated array of equations.
    static func generate(amount: Int, using settings: GeneratorSettings) -> [MathEquation] {
        var equations: [MathEquation] = []
        
        for _ in 0 ..< amount {
            let (lhs, rhs, operation) = createExpression(using: settings)
            let string = "\(lhs)\(operation.symbol)\(rhs)"
            
            let equation = MathEquation(string: string)
            equations.append(equation)
        }
        
        return equations
    }
    
    /// Creates an expression using provided settings.
    /// - Parameter settings: The settings to use for generating the expression.
    /// - Returns: A tuple containing a mathematical expression.
    private static func createExpression(using settings: GeneratorSettings) -> Expression {
        let operation = MathOperation.selectRandom(from: settings.operations)
        var (lhs, rhs): (Int, Int)
        
        func randomInt(highest: Int? = nil) -> Int {
            Int.random(in: settings.lowestNumber...(highest ?? settings.highestNumber))
        }
        
        switch operation {
        case .subtraction:
            let left = randomInt()
            (lhs, rhs) = (left, randomInt(highest: left))
        case .division:
            let (left, right) = (randomInt(), randomInt())
            (lhs, rhs) = (left * right, right)
        default:
            (lhs, rhs) = (randomInt(), randomInt())
        }
        
        return (lhs, rhs, operation)
    }
    
    /// A settings structure for math equation generators.
    struct GeneratorSettings {
        
        /// The lowest number to use in an equation. Defaults to 1.
        var lowestNumber: Int
        
        /// The highest number to use in an equation.
        var highestNumber: Int
        
        /// The computed range of numbers based on the lowest and highest settings.
        var numberRange: Range<Int> {
            Range(lowestNumber...highestNumber)
        }
        
        /// An array of operations for the generator to use.  Defaults to all.
        var operations: [MathOperation]
    }
}
