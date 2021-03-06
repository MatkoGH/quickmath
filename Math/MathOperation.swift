//
//  MathOperation.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-09.
//

import Foundation

/// An enum for math operations.
enum MathOperation: Codable {
    
    /// Addition math operation.
    case addition
    
    /// Subtraction math operation.
    case subtraction
    
    /// Multiplication math operation.
    case multiplication
    
    /// Division math operation.
    case division
    
    /// An array of all math operations.
    static let all: [Self] = [.addition, .subtraction, .multiplication, .division]
    
    /// An array of math operations, using the BEDMAS order of operations.
    static let orderOfOperations: [Self] = [.division, .multiplication, .addition, .subtraction]
    
    /// The name of the math operation.
    var name: String {
        switch self {
        case .addition: return "Addition"
        case .subtraction: return "Subtraction"
        case .multiplication: return "Multiplication"
        case .division: return "Division"
        }
    }
    
    /// The symbol for the math operation.
    var symbol: String {
        switch self {
        case .addition: return "+"
        case .subtraction: return "-"
        case .multiplication: return "*"
        case .division: return "/"
        }
    }
    
    /// The symbol to display for the math operation.
    var displaySymbol: String {
        switch self {
        case .addition: return "+"
        case .subtraction: return "-"
        case .multiplication: return "×"
        case .division: return "÷"
        }
    }
    
    /// Select a random math operation.
    /// - Parameter operations: An array of operations
    static func selectRandom(from operations: [MathOperation]) -> MathOperation {
        operations.randomElement() ?? MathOperation.all.randomElement()!
    }
}

// MARK: - Comparable

extension MathOperation: Comparable {
    
    static func > (lhs: MathOperation, rhs: MathOperation) -> Bool {
        switch (lhs, rhs) {
        case (.addition, .subtraction): return true
        case (.addition, .multiplication): return true
        case (.addition, .division): return true
            
        case (.subtraction, .multiplication): return true
        case (.subtraction, .division): return true
            
        case (.multiplication, .division): return true
            
        default: return false
        }
    }
}
