//
//  QuizConfigDataView.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-23.
//

import SwiftUI

struct QuizConfigDataView: View {
    
    /// A reference to a namespace passed into the environment.
    @Environment(\.namespace) var namespace
    
    /// The quiz object passed down in the environment.
    @EnvironmentObject var quiz: Quiz
    
    /// The configuration type.
    let configType: QuizConfigEditView.ConfigType
    
    /// Boolean indicating whether the config type is being edited.
    var isEditing: Bool = false
    
    /// Creates a quiz config data view.
    /// - Parameters:
    ///   - configType: The configuration type.
    ///   - isEditing: Boolean indicating whether the config type is being edited.
    init(for configType: QuizConfigEditView.ConfigType, isEditing: Bool = false) {
        self.configType = configType
        self.isEditing = isEditing
    }
    
    var body: some View {
        ZStack {
            switch configType {
            case .numberOfEquations:
                configView(title: "Number of Questions", value: "\(quiz.configuration.numberOfEquations)", systemImage: "number")
            case .solveTime:
                configView(title: "Solve Time per Question", value: "\(quiz.configuration.solveTime.toString(style: .suffixed))", systemImage: "timer")
            case .numberRange:
                configView(title: "Number Range", value: "\(quiz.configuration.lowestNumber) to \(quiz.configuration.highestNumber)", systemImage: "plus.forwardslash.minus")
            case .operations:
                configView(title: "Allowed Operations", value: "\(quiz.configuration.operations.map({ $0.displaySymbol }).joined(separator: " / "))", systemImage: "checkmark.circle")
            }
        }
        .padding(style: .default)
        .background(K.fillColor, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .matchedGeometryEffect(id: "quiz-setting-\(configType)", in: namespace)
    }
    
    func configView(title: String, value: String, systemImage: String) -> some View {
        HStack(spacing: 8) {
            Label(title, systemImage: systemImage)
                .font(.body.bold())
            Spacer()
            Text(value)
                .font(.body.weight(.medium))
                .foregroundColor(.accentColor)
            Image(systemName: "pencil")
                .foregroundColor(isEditing ? .accentColor : .secondary)
        }
    }
}
