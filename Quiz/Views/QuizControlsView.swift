//
//  QuizControlsView.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-17.
//

import SwiftUI

struct QuizControlsView: View {
    
    /// The quiz object passed down in the environment.
    @EnvironmentObject var quiz: Quiz
    
    /// The question to show controls for.
    @ObservedObject var question: Quiz.Question
    
    /// Boolean indicating whether the skip button has been tapped once.
    @State private var skipTapped: Bool = false
    
    /// Boolean indicating whether to show the alert for exiting the active quiz.
    @State private var isExiting: Bool = false
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 16) {
                HStack(spacing: 8) {
                    exitButtonView
                    currentInfoView
                }
                Spacer()
                timeView
            }
            Spacer()
            HStack(alignment: .bottom, spacing: 16) {
                predictionView
                Spacer()
                if !question.hasAnswered() {
                    answeringControls(number: question.answer)
                }
            }
        }
    }
    
    var currentInfoView: some View {
        Group {
            if let percentage = quiz.correctPercentage {
                Text("\(percentage.toString())%")
                    .foregroundColor(.percentageColor(for: percentage))
            } else {
                Text("--%")
                    .foregroundColor(.secondary)
            }
        }
        .font(.body.weight(.medium).monospacedDigit())
        .padding(style: .small)
        .roundBackground(material: .ultraThinMaterial)
        .transition(.opacity)
    }
    
    var exitButtonView: some View {
        Button {
            isExiting = true
        } label: {
            Label("Exit", systemImage: "chevron.left")
                .font(.body.weight(.medium))
        }
        .tint(.red)
        .padding(style: .small)
        .roundBackground(material: .ultraThinMaterial)
        .hoverEffect(.lift)
        .alert("Are you sure?", isPresented: $isExiting) {
            Button(role: .destructive) {
                withAnimation(.defaultSpring) { quiz.restart() }
                isExiting = false
            } label: {
                Text("Exit")
            }

            Button(role: .cancel) {
                isExiting = false
            } label: {
                Text("Cancel")
            }
        } message: {
            Text("Exiting will make you lose your current quiz progress.")
        }
    }
    
    var timeView: some View {
        Label("\(quiz.timeTaken.toString())", systemImage: "clock")
            .font(.body.weight(.medium).monospacedDigit())
            .foregroundColor(.primary)
            .padding(style: .small)
            .roundBackground(material: .ultraThinMaterial)
    }
    
    var predictionView: some View {
        Group {
            if let answer = question.answer, !question.hasAnswered() {
                HStack(spacing: 8) {
                    Image(systemName: "text.viewfinder")
                        .font(.title2)
                    VStack(alignment: .leading) {
                        Text("My prediction: \(answer)")
                            .font(.body.weight(.medium))
                        Text("I may not recognize numbers correctly.")
                            .font(.callout)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(style: .small)
                .roundBackground(material: .ultraThinMaterial)
                .transition(.opacity)
            } else if let isCorrect = question.answerState?.isCorrect {
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
                    question.clearDrawing()
                }
            } label: {
                Label("Clear", systemImage: "trash.fill")
            }
            .buttonStyle(.quizStyle(color: .constant(number != nil ? .red : .gray), isDisabled: number == nil))
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
            .buttonStyle(QuizButtonStyle(color: .constant(.orange)))
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
            question.skip()
            quiz.nextQuestion()
            skipTapped = false
        }
    }
}

struct QuizButtonStyle: ButtonStyle {
    
    /// A binding for the background color to use.
    @Binding var color: Color
    
    /// Boolean indicating whether the button is disabled.
    var isDisabled: Bool = false
    
    /// Boolean indicating whether the button is being hovered over.
    @State private var isHovering: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.medium))
            .foregroundColor(.white)
            .colorMultiply(!isDisabled ? .white : .gray)
            .fixedSize(horizontal: false, vertical: true)
            .padding(style: .default)
            .frame(maxHeight: .infinity, alignment: .center)
            .background(!isDisabled ? color : .clear)
            .roundBackground(material: .ultraThinMaterial)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.9), value: configuration.isPressed || isDisabled)
            .hoverEffect(.lift)
    }
}

extension ButtonStyle where Self == QuizButtonStyle {
    
    /// The quiz button style.
    /// - Parameters:
    ///   - color: A binding for the background color to use.
    ///   - isDisabled: Boolean indicating whether the button is disabled.
    static func quizStyle(color: Binding<Color>, isDisabled: Bool = false) -> Self {
        .init(color: color, isDisabled: isDisabled)
    }
}
