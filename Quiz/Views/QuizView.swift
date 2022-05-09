//
//  Quiz.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-19.
//

import SwiftUI

struct QuizView: View {
 
    /// The quiz object passed down in the environment.
    @EnvironmentObject var quiz: Quiz
    
    var body: some View {
        Group {
            switch quiz.state {
            case .notStarted:
                QuizSetupView()
            case .running:
                runningView
            case .ended:
                QuizEndedView()
            }
        }
        .transition(.moveAcross)
    }
    
    var runningView: some View {
        ZStack {
            ForEach(quiz.questions) { question in
                if quiz.currentQuestion === question {
                    QuizQuestionView(question: question)
                        .transition(.moveAcross)
                        .onChange(of: question.answerState) { newValue in
                            guard newValue != nil else { return }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                                withAnimation(.defaultSpring) { quiz.nextQuestion() }
                            }
                        }
                }
            }
            
            QuizControlsView(question: quiz.currentQuestion)
                .padding(style: .default)
        }
    }
}
