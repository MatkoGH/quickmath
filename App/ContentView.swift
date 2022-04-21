import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var quiz: Quiz
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("grid")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .opacity(0.15)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .ignoresSafeArea(.all, edges: .all)
                
                QuizView()
                    .environmentObject(quiz)
            }
        }
    }
}
