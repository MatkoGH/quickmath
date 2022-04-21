//
//  QuizQuestionView.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-11.
//

import SwiftUI

struct QuizQuestionView: View {
    
    @EnvironmentObject var quiz: Quiz
    @ObservedObject var question: Quiz.Question
    
    @Namespace private var quizQuestionNamespace
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
                                .matchedGeometryEffect(id: "title", in: quizQuestionNamespace)
                                .frame(maxWidth: .infinity, alignment: .top)
                            Spacer()
                        }
                    } else {
                        equationTitleView
                            .scaleEffect(1.5)
                            .matchedGeometryEffect(id: "title", in: quizQuestionNamespace)
                            .zIndex(2)
                    }
                }
                .padding()
            }
            .onAppear {
                toggleLargeEquation(to: false, delay: 2.0)
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
        }
    }
    
    func toggleLargeEquation(to toggle: Bool, delay: TimeInterval = .zero) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(round(delay * 100)))) {
            withAnimation(.spring(response: 0.4, dampingFraction: 1.0, blendDuration: 0.5).delay(toggle ? 0.0 : 1.0)) {
                isShowingLargeEquation = toggle
            }
        }
    }
}
