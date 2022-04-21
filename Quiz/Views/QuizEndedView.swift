//
//  QuizEndedView.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-20.
//

import SwiftUI

struct QuizEndedView: View {
    
    @EnvironmentObject var quiz: Quiz
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 4) {
                Text("You got...")
                    .font(.title3)
                    .foregroundColor(.secondary)
                Text("\(quiz.correctPercentage != nil ? quiz.correctPercentage!.toString() : "--")%")
                    .font(K.largeRoundedFont.bold().monospacedDigit())
                    .foregroundColor(.percentageColor(for: quiz.correctPercentage))
            }
            
            VStack(spacing: 8) {
                titleView
                    .padding(16)
                
                VStack {
                    dataView(title: "Total Questions", value: String(quiz.questions.count), systemImage: "number")
                    dataView(title: "Skipped Equations", value: String(quiz.questions.filter({ $0.answerState == .skipped }).count), systemImage: "chevron.right.2")
                }
                
                buttonsView
                    .padding(16)
                    .padding(.top, 8)
            }
            .padding(style: .default)
            .roundBackground(material: .ultraThinMaterial)
        }
        .frame(maxWidth: 512)
        .padding()
    }
    
    var titleView: some View {
        VStack(spacing: 4) {
            Text(text.title)
                .font(.title.bold())
                .foregroundColor(.primary)
            Text(text.description)
                .font(.title3.weight(.medium))
                .foregroundColor(.secondary)
        }
    }
    
    var buttonsView: some View {
        HStack(spacing: 12) {
            Button {
                quiz.restart()
            } label: {
                Label("Restart", systemImage: "arrow.counterclockwise")
            }
            .buttonStyle(.quizInfoStyle(color: .constant(.accentColor), isDisabled: false))
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
    func dataView(title: String, value: String, systemImage: String) -> some View {
        VStack {
            Divider()
            HStack(alignment: .center, spacing: 16) {
                Label(title, systemImage: systemImage)
                Spacer()
                Text(value)
            }
            .padding(.vertical, 4)
        }
    }
    
    var text: (title: String, description: String) {
        guard let percentage = quiz.correctPercentage, percentage >= 0, percentage <= 100 else {
            return ("Something went wrong.", "Please try again.")
        }

        switch percentage {
        case 0...49:
            return ("You need more practice.", "You got less then half of the questions correct. The only way to be better is by practicing.")
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

struct QuizEndedView_Previews: PreviewProvider {
    
    @StateObject static var quiz: Quiz = .init(using: .init(amountOfEquations: 10, solveTime: 10, generatorSettings: .init(highestNumber: 10)))
    
    static var previews: some View {
        QuizEndedView()
            .environmentObject(quiz)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
