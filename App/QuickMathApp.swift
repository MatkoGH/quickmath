//
//  QuickMathApp.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-07.
//

import SwiftUI

@main
struct QuickMathApp: App {
    
    /// A stored boolean indicating whether the user is onboarding.
    @AppStorage("onboarding") var isOnboarding: Bool = true
    
    /// A stored copy of the active quiz configuration.
    @AppStorage("quiz-config") var storedConfiguration: Data = .init()
    
    /// The quiz object.
    @StateObject var quiz: Quiz = .init(using: .default)
     
    var body: some Scene {
        WindowGroup {
            ContentView(quiz: quiz, isOnboarding: $isOnboarding)
                .environmentObject(quiz)
                .onChange(of: quiz.configuration) { newConfiguration in
                    quiz.configurationUpdated()
                    
                    if let encoded = try? JSONEncoder().encode(newConfiguration) {
                        storedConfiguration = encoded
                    }
                }
                .onAppear {
                    if let decoded = try? JSONDecoder().decode(Quiz.Configuration.self, from: storedConfiguration) {
                        quiz.configuration = decoded
                    }
                }
        }
    }
}
