//
//  Quiz.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-19.
//

import SwiftUI

struct QuizView: View {
 
    @EnvironmentObject var quiz: Quiz
    
    var body: some View {
        Group {
            switch quiz.state {
            case .notStarted:
                notStartedView
            case .running:
                runningView
            case .ended:
                QuizEndedView()
            }
        }
        .onAppear {
            quiz.start()
        }
    }
    
    var notStartedView: some View {
        Text("Not started.")
    }
    
    var runningView: some View {
        ZStack {
            ForEach(quiz.questions) { question in
                if quiz.currentQuestion === question {
                    QuizQuestionView(question: question)
                        .transition(.moveAcross)
                        .onChange(of: question.answerState) { newValue in
                            if case .answered(_) = newValue {
                                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                                    withAnimation(.defaultSpring) { quiz.nextQuestion() }
                                }
                            }
                        }
                }
            }
            
            QuizInfoView(question: quiz.currentQuestion)
            .padding(style: .default)
        }
    }
}
