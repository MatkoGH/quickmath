//
//  QuizInfoView.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-17.
//

import SwiftUI

struct QuizInfoView: View {
    
    @EnvironmentObject var quiz: Quiz
    @ObservedObject var question: Quiz.Question
    
    @Namespace private var quizInfoNamespace
    
    @State private var skipTapped: Bool = false
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 16) {
                currentInfoView
                Spacer()
                timeView
            }
            Spacer()
            HStack(alignment: .bottom, spacing: 16) {
                predictionView
                Spacer()
                if case .answering(let number) = question.answerState {
                    answeringControls(number: number)
                }
            }
        }
    }
    
    var currentInfoView: some View {
        Group {
            if let percentage = quiz.correctPercentage {
                Text("\(percentage.toString(minimumNumberCount: 2))%")
                    .font(.body.weight(.medium).monospacedDigit())
                    .foregroundColor(.percentageColor(for: percentage))
                    .transition(.opacity)
            } else {
                Text("--%")
                    .font(.body.weight(.medium).monospacedDigit())
                    .foregroundColor(.secondary)
                    .transition(.opacity)
            }
        }
        .padding(style: .small)
        .roundBackground(material: .ultraThinMaterial)
    }
    
    var timeView: some View {
        Label("\(quiz.timeTaken.toTimeString())", systemImage: "clock")
            .font(.body.weight(.medium).monospacedDigit())
            .foregroundColor(.primary)
            .padding(style: .small)
            .roundBackground(material: .ultraThinMaterial)
    }
    
    var predictionView: some View {
        Group {
            if case .answering(let number) = question.answerState, let number = number {
                HStack(spacing: 8) {
                    Image(systemName: "text.viewfinder")
                        .font(.title2)
                    VStack(alignment: .leading) {
                        Text("My prediction: \(number)")
                            .font(.body.weight(.medium))
                        Text("I may not recognize numbers correctly.")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(style: .small)
                .roundBackground(material: .ultraThinMaterial)
                .transition(.opacity)
            } else if case .answered(let isCorrect) = question.answerState {
                HStack(spacing: 8) {
                    Image(systemName: isCorrect ? "checkmark" : "xmark")
                        .font(.title2.bold())
                        .foregroundColor(isCorrect ? .green : .red)
                    VStack(alignment: .leading) {
                        Text("Your answer is \(isCorrect ? "correct" : "incorrect")!")
                            .font(.body.weight(.medium))
                            .foregroundColor(isCorrect ? .green : .red)
                        Text(isCorrect ? "Great job! Moving to next question..." : "Make sure to practice! Moving to next equation...")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(style: .small)
                .roundBackground(material: .ultraThinMaterial)
                .transition(.opacity)
            } else {
                HStack(spacing: 8) {
                    Image(systemName: "scribble")
                        .font(.title2)
                    VStack(alignment: .leading) {
                        Text("Write anywhere.")
                            .font(.body.weight(.medium))
                        Text("I may not recognize all numbers correctly.")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(style: .small)
                .roundBackground(material: .ultraThinMaterial)
                .transition(.opacity)
            }
        }
    }
    
    func answeringControls(number: Int?) -> some View {
        HStack {
            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.9, blendDuration: 0.5)) {
                    question.clearAnswer()
                }
            } label: {
                Label("Clear", systemImage: "trash.fill")
            }
            .buttonStyle(.quizInfoStyle(color: .constant(number != nil ? .red : .gray), isDisabled: number == nil))
            .animation(.spring(response: 0.4, dampingFraction: 1.0), value: question.answerState)
            .disabled(number == nil)
            
            Button {
                skipWasTapped()
            } label: {
                HStack(spacing: 8) {
                    Text("Skip")
                    Image(systemName: "chevron.right\(skipTapped ? ".2" : "")")
                        .transition(.opacity)
                }
            }
            .buttonStyle(QuizInfoButtonStyle(color: .constant(.orange)))
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
    func skipWasTapped() {
        guard skipTapped else {
            skipTapped = true
            
            DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + .seconds(2)) {
                withAnimation(.defaultSpring) {
                    self.skipTapped = false
                }
            }
            
            return
        }
        
        withAnimation(.defaultSpring) {
            quiz.nextQuestion()
            skipTapped = false
        }
    }
}

struct QuizInfoButtonStyle: ButtonStyle {
    
    @Binding var color: Color
    var isDisabled: Bool = false
    
    @State private var isHovering: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.medium))
            .foregroundColor(.white)
            .colorMultiply(!isDisabled ? .white : .gray)
            .padding(style: .default)
            .frame(maxHeight: .infinity)
            .background(!isDisabled ? color : .clear)
            .roundBackground(material: .ultraThinMaterial)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.9), value: configuration.isPressed || isDisabled)
            .hoverEffect(.lift)
    }
}

extension ButtonStyle where Self == QuizInfoButtonStyle {
    
    static func quizInfoStyle(color: Binding<Color>, isDisabled: Bool) -> Self {
        .init(color: color, isDisabled: isDisabled)
    }
}
