//
//  OnboardingView.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-24.
//

import SwiftUI

struct OnboardingView: View {
    
    /// A stored boolean indicating whether the user is onboarding.
    @AppStorage("onboarding") var isOnboarding: Bool = true
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                VStack(spacing: 2) {
                    Text("Welcome to")
                        .font(.title3.weight(.medium))
                        .foregroundColor(.secondary)
                    Text("QuickMath")
                        .font(K.largeRoundedFont.bold())
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: true, vertical: false)
                }
                
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 24) {
                        VStack(spacing: 4) {
                            Text("How to Use QuickMath")
                                .font(.title.bold())
                                .foregroundColor(.primary)
                            Text("You can come back to this tutorial at any time.")
                                .font(.body.weight(.medium))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        
                        VStack(spacing: 8) {
                            tutorialSection("Set Up a Quiz", number: 1, text: "There are multiple settings you can use to customize your quiz. Set the values to your liking, then move on.")
                            tutorialSection("Take the Quiz", number: 2, text: "The quiz taker will be asked a series of equations. The equations are generated according to your settings.")
                            tutorialSection("Get Your Results", number: 3, text: "Upon finishing the quiz, you will be presented with your score. Celebrate if you did well!")
                        }
                        
                        Button {
                            withAnimation(.defaultSpring) { isOnboarding = false }
                        } label: {
                            Label("Get Started", systemImage: "arrow.right.circle.fill")
                        }
                        .buttonStyle(.quizStyle(color: .constant(.accentColor)))
                    }
                }
                .padding(.vertical, 16)
                .padding(style: .default)
                .roundBackground(material: .ultraThinMaterial)
                .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: 512, maxHeight: UIScreen.main.bounds.height * 0.7)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func tutorialSection(_ title: String, number: Int, text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "\(number).circle")
                .font(.title3.weight(.semibold))
                .foregroundColor(.primary)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title3.bold())
                    .foregroundColor(.primary)
                Text(text)
                    .font(.body.weight(.medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer(minLength: 0)
        }
        .padding(style: .default)
        .roundBackground(color: K.fillColor)
    }
}
