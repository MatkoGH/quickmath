//
//  ContentView.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-07.
//

import SwiftUI

struct ContentView: View {

    /// A reference to the quiz object.
    @ObservedObject var quiz: Quiz
    
    /// Boolean binding indicating whether the onboarding view is active.
    @Binding var isOnboarding: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("grid")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.15)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .ignoresSafeArea(.all, edges: .all)

                if isOnboarding {
                    OnboardingView()
                        .transition(.slide.combined(with: .opacity))
                } else {
                    QuizView()
                        .environmentObject(quiz)
                        .transition(.slide.combined(with: .opacity))
                }
            }
        }
    }
}
