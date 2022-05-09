//
//  QuizEndedView.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-20.
//

import SwiftUI

struct QuizEndedView: View {
    
    /// A reference to a namespace passed into the environment.
    @Environment(\.namespace) var quizNamespace
    
    /// The quiz object passed down in the environment.
    @EnvironmentObject var quiz: Quiz
    
    /// Boolean indicating whether the view is currently animating.
    @State var isAnimating: Bool = false
    
    /// Boolean indicating whether the ended details are showing.
    @State var isShowingDetails: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                if let correctPercentage = quiz.correctPercentage {
                    VStack(spacing: 4) {
                        Text("You got...")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        Text("\(correctPercentage.toString())%")
                            .font(K.largeRoundedFont.bold().monospacedDigit())
                            .foregroundColor(.percentageColor(for: correctPercentage))
                            .opacity(isAnimating ? 1.0 : 0.0)
                            .scaleEffect(isAnimating ? 1.0 : 0.75)
                    }
                }
                
                if isShowingDetails {
                    VStack(spacing: 24) {
                        titleView
                        
                        if quiz.correctPercentage != nil {
                            VStack(spacing: 8) {
                                dataView(title: "Total Time", value: quiz.timeTaken.toString(), systemImage: "clock")
                                dataView(title: "Questions Correct", value: "\(quiz.questions.filter({ $0.answerState == .correct }).count) of \(quiz.questions.count)", systemImage: "number")
                                dataView(title: "Questions Skipped", value: "\(quiz.skippedQuestions.count)", systemImage: "chevron.right.2")
                            }
                        }
                        
                        buttonsView
                    }
                    .padding(.vertical, 16)
                    .padding(style: .default)
                    .roundBackground(material: .ultraThinMaterial)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .frame(maxWidth: 512)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85).delay(0.5)) {
                isAnimating = true
            }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85).delay(1.5)) {
                isShowingDetails = true
            }
        }
    }
    
    var titleView: some View {
        VStack(spacing: 4) {
            Text(text.title)
                .font(.title.bold())
                .foregroundColor(.primary)
            Text(text.description)
                .font(.body.weight(.medium))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    var buttonsView: some View {
        HStack(spacing: 12) {
            Button {
                withAnimation(.defaultSpring) {
                    quiz.restart()
                }
            } label: {
                Label("Home", systemImage: "house.fill")
            }
            .buttonStyle(.quizStyle(color: .constant(.accentColor), isDisabled: false))
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
    func dataView(title: String, value: String, systemImage: String) -> some View {
        HStack(alignment: .center, spacing: 16) {
            Label(title, systemImage: systemImage)
                .font(.body.bold())
            Spacer()
            Text(value)
                .font(.body.weight(.medium))
                .foregroundColor(.accentColor)
        }
        .padding(style: .default)
        .background(K.fillColor, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
    
    var text: (title: String, description: String) {
        guard let percentage = quiz.correctPercentage, percentage >= 0, percentage <= 100 else {
            return ("Something went wrong.", "Please try again.")
        }

        switch percentage {
        case 0...49:
            return ("You need more practice.", "You got less then half of the questions correct. The only way to get better is to practice.")
        case 50...74:
            return ("Good work.", "You got more than half of the questions correct. A little more practice will make you better.")
        case 75...99:
            return ("Awesome job!", "You got most of the questions correct! That's awesome work.")
        case 100:
            return ("Outstanding job!", "You got everything correct! Your practice has paid off.")
        default:
            return ("Something went wrong.", "Please try again.")
        }
    }
}
