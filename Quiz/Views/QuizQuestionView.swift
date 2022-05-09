//
//  QuizQuestionView.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-11.
//

import SwiftUI

struct QuizQuestionView: View {
    
    /// The quiz object passed down in the environment.
    @EnvironmentObject var quiz: Quiz
    
    /// The question to display in the view.
    @ObservedObject var question: Quiz.Question
    
    /// A namespace used for matching animations.
    @Namespace private var namespace
    
    /// Boolean indicating whether the view is showing the large version of the equation.
    @State private var isShowingLargeEquation = true
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                QuizInputView(question: question)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .ignoresSafeArea()
                
                Group {
                    if !isShowingLargeEquation {
                        VStack {
                            equationTitleView
                                .matchedGeometryEffect(id: "title", in: namespace)
                                .frame(maxWidth: .infinity, alignment: .top)
                            Spacer()
                        }
                    } else {
                        equationTitleView
                            .scaleEffect(1.5)
                            .matchedGeometryEffect(id: "title", in: namespace)
                            .zIndex(2)
                    }
                }
                .padding()
            }
            .disabled(isShowingLargeEquation)
            .onAppear {
                toggleLargeEquation(to: false, delay: 2.0)
            }
            .onChange(of: isShowingLargeEquation) { newValue in
                if !newValue {
                    question.startTimer()
                }
            }
        }
    }
    
    var equationTitleView: some View {
        VStack(spacing: 2) {
            Text("Question \(quiz.currentQuestionIndex + 1) of \(quiz.questions.count)")
                .font(.body)
                .foregroundColor(.secondary)
            Text(question.equation.displayString)
                .font(K.largeRoundedFont.weight(.bold))
                .foregroundColor(.primary)
            
            if let timeLeft = question.timeLeft {
                Label(timeLeft.toString(), systemImage: "timer")
                    .font(.body.weight(.medium).monospacedDigit())
                    .foregroundColor(.white)
                    .colorMultiply(question.answerState != nil ? .secondary : .red)
                    .padding(style: .small)
                    .roundBackground(material: .ultraThinMaterial)
                    .animation(.linear(duration: 0.25), value: question.answerState)
            }
        }
    }
    
    /// Toggles the large equation view.
    /// - Parameters:
    ///   - toggle: Boolean indicating whether the large equation view should be shown.
    ///   - delay: The amount of time, in milliseconds, to delay the animation.
    func toggleLargeEquation(to toggle: Bool, delay: TimeInterval = .zero) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(round(delay * 100)))) {
            withAnimation(.spring(response: 0.4, dampingFraction: 1.0, blendDuration: 0.5).delay(toggle ? 0.0 : 1.0)) {
                isShowingLargeEquation = toggle
            }
        }
    }
}
