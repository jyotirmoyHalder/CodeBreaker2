//
//  CodeBreakerView.swift
//  CodeBreaker2
//
//  Created by jyotirmoy_halder on 5/2/26.
//

import SwiftUI

struct CodeBreakerView: View {
    // MARK: Data Owned by Me
    @State private var game: CodeBreaker = CodeBreaker(pegChoices: [.brown, .yellow, .orange, .black, .green])
    
    @State private var selection = 0
    
    // MARK: - Body
    var body: some View {
        VStack {
            CodeView(code: game.masterCode)
//                .transaction { transaction in
//                    if game.masterCode.kind == .master(isHidden: false) {
//                        transaction.animation = .none
//                    }
//                }
            ScrollView {
                if !game.isOver {
                    CodeView(code: game.guess, selection: $selection) {
                            guessButton
                    }
                }
                
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    CodeView(code: game.attempts[index], selection: $selection) {
                        if let matches = game.attempts[index].matches {
                            MatchMarkers(matches: matches)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            PegChooser(choices: game.pegChoices, onChoose: changePegAtSelection)
        }
        .padding()
    }
    
    func changePegAtSelection(to peg: Peg) {
        game.setGuessPeg(peg, at: selection)
        selection = (selection + 1) % game.masterCode.pegs.count
    }
    
    
    var guessButton: some View {
        Button {
            withAnimation {
                game.attemptGuess()
                selection = 0
            }
        } label: {
            Text("Guess")
                .font(.system(size: GuessButton.maximumFontSize))
                .minimumScaleFactor(GuessButton.scaleFactor)
                .fontWeight(.bold)
        }
    }
    
    
    struct GuessButton {
        static let minimumFontSize: CGFloat = 8
        static let maximumFontSize: CGFloat = 80
        static let scaleFactor = minimumFontSize / maximumFontSize
    }
    
}

extension Color {
    static func gray(_ brightness: CGFloat) -> Color {
        Color(hue: 148/360, saturation: 0, brightness: brightness)
    }
}

#Preview {
    CodeBreakerView()
}
