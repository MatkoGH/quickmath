import SwiftUI

@main
struct QuickMathApp: App {
    
    @StateObject var quiz: Quiz = .init(using: .init(amountOfEquations: 5, solveTime: 10, generatorSettings: .init(highestNumber: 15)))
     
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(quiz)
        }
    }
}
