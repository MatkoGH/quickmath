//
//  QuizSetupView.swift
//  QuickMath
//
//  Created by Martin Stric on 2022-04-21.
//

import SwiftUI

struct QuizSetupView: View {
    
    /// A stored boolean indicating whether the user is onboarding.
    @AppStorage("onboarding") var isOnboarding: Bool = false
    
    /// The quiz object passed down in the environment.
    @EnvironmentObject var quiz: Quiz
    
    /// A namespace used for matching animations.
    @Namespace var namespace
    
    /// Boolean indicating whether there is a configuration value being edited.
    @State var isEditing: Bool = false
    
    /// The optional config type actively being edited.
    @State var configType: QuizConfigEditView.ConfigType? = nil
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                VStack(spacing: 4) {
                    Text("👋 Hey there!")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    Text("QuickMath")
                        .font(K.largeRoundedFont.bold())
                        .foregroundColor(.primary)
                }
                
                ZStack {
                    if let configType = configType, isEditing {
                        QuizConfigEditView(isEditing: $isEditing, configType: configType)
                            .environment(\.namespace, namespace)
                            .transition(.opacity)
                    } else {
                        infoView
                            .frame(maxWidth: 512)
                            .transition(.opacity)
                    }
                }
                .padding(.vertical, 16)
                .padding(style: .default)
                .roundBackground(material: .ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            .frame(maxWidth: 512)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var infoView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 4) {
                Text("Quiz Configuration")
                    .font(.title.bold())
                    .foregroundColor(.primary)
                Text("Modify your quiz by pressing any of the settings below.")
                    .font(.body.weight(.medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 8) {
                configDataViewButton(for: .numberOfEquations)
                configDataViewButton(for: .solveTime)
                configDataViewButton(for: .numberRange)
                configDataViewButton(for: .operations)
            }
            
            buttonsView
        }
    }
    
    func configDataViewButton(for configType: QuizConfigEditView.ConfigType) -> some View {
        Button {
            withAnimation(.defaultSpring) {
                self.configType = configType
                self.isEditing = true
            }
        } label: {
            QuizConfigDataView(for: configType)
                .namespace(namespace)
        }
        .tint(.primary)
    }
    
    var buttonsView: some View {
        HStack(spacing: 8) {
            Button {
                withAnimation(.defaultSpring) { isOnboarding = true }
            } label: {
                Label("Tutorial", systemImage: "questionmark.circle.fill")
            }
            .buttonStyle(.quizStyle(color: .constant(.gray)))
            .fixedSize(horizontal: false, vertical: true)
            
            Button {
                withAnimation(.defaultSpring) {
                    quiz.start()
                }
            } label: {
                Label("Start Quiz", systemImage: "play.fill")
            }
            .buttonStyle(.quizStyle(color: .constant(.accentColor)))
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}
