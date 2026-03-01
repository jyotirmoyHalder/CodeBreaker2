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
            CodeView(code: game.masterCode, selection: $selection, ancillaryView: { EmptyView() })
            ScrollView {
                CodeView(code: game.guess, selection: $selection, ancillaryView: {
                        guessButton
                } )
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    CodeView(
                        code: game.attempts[index],
                        selection: $selection,
                        ancillaryView:{
                            MatchMarkers(matches: game.attempts[index].matches ?? [])
                        })
                }
            }
            .scrollIndicators(.hidden)
            PegChooser(choices: game.pegChoices) { peg in
                game.setGuessPeg(peg, at: selection)
                selection = (selection + 1) % game.masterCode.pegs.count
            }
        }
        .padding()
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
