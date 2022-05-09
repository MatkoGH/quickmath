//
//  QuizConfigEditView.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-22.
//

import SwiftUI

struct QuizConfigEditView: View {
    
    /// The quiz object passed down in the environment.
    @EnvironmentObject var quiz: Quiz
    
    /// Boolean indicating whether the config type is being edited.
    @Binding var isEditing: Bool
    
    /// The configuration type.
    var configType: ConfigType
    
    var body: some View {
        VStack(spacing: 16) {
            QuizConfigDataView(for: configType, isEditing: true)
                .zIndex(2)
            
            switch configType {
            case .numberOfEquations:
                amountOfEquations
            case .solveTime:
                solveTime
            case .numberRange:
                numberRange
            case .operations:
                operations
            }
            
            Button {
                withAnimation(.defaultSpring) {
                    isEditing = false
                }
            } label: {
                Label("Back", systemImage: "chevron.left")
                    .fixedSize(horizontal: true, vertical: true)
            }
            .buttonStyle(.quizStyle(color: .constant(.red), isDisabled: false))
            .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    var amountOfEquations: some View {
        Picker("Choose Number", selection: $quiz.configuration.numberOfEquations) {
            ForEach(1...100, id: \.self) { number in
                Text("\(number)")
                    .tag(number)
            }
        }
        .pickerStyle(.wheel)
    }
    
    var solveTime: some View {
        Picker("Choose Solve Time", selection: $quiz.configuration.solveTime) {
            ForEach(Quiz.Configuration.solveTimes, id: \.self) { solveTime in
                Text("\(solveTime.toString())")
                    .font(.title2.monospacedDigit())
                    .tag(solveTime)
            }
        }
        .pickerStyle(.wheel)
    }
    
    var numberRange: some View {
        MultiNumberPicker(
            range: Quiz.Configuration.numberRange,
            lowestNumber: $quiz.configuration.lowestNumber,
            highestNumber: $quiz.configuration.highestNumber)
    }
    
    var operations: some View {
        VStack(spacing: 8) {
            LazyVGrid(columns: [.init(), .init()], spacing: 8) {
                ForEach(MathOperation.all, id: \.self) { operation in
                    operationButton(for: operation, isActive: quiz.configuration.operations.contains(operation))
                }
            }
        }
    }
    
    func operationButton(for operation: MathOperation, isActive: Bool) -> some View {
        Button {
            quiz.configuration.toggleOperation(operation)
        } label: {
            Label("Allow \(operation.name)", systemImage: isActive ? "checkmark.circle.fill" : "checkmark.circle")
                .frame(maxWidth: .infinity)
        }
        .tint(.white)
        .buttonStyle(.quizStyle(color: .init(get: { isActive ? .green : .red }, set: { _ in })))
    }
    
    enum ConfigType {
        case numberOfEquations
        case solveTime
        case numberRange
        case operations
    }
}
