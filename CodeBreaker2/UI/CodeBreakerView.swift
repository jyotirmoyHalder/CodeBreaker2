//
//  CodeBreakerView.swift
//  CodeBreaker2
//
//  Created by jyotirmoy_halder on 5/2/26.
//

import SwiftUI

struct CodeBreakerView: View {
    // MARK: Data In
    @Environment(\.words) var words
    
    // MARK: Data Shared with Me
    let game: CodeBreaker

    
    // MARK: Data Owned by Me
    
    @State private var selection = 0
    @State private var restarting = false
    @State private var hideMostRecentMarkers = false
    
    // MARK: - Body
    var body: some View {
        VStack {
            CodeView(code: game.masterCode)
            ScrollView {
                if !game.isOver {
                    CodeView(code: game.guess, selection: $selection) {
                        Button("Guess", action: guess).flexibleSystemFont()
                    }
                    .animation(nil, value: game.attempts.count)
                    .opacity(restarting ? 0 : 1)
                }
                
                ForEach(game.attempts, id: \.pegs) { attempt in
                    CodeView(code: attempt, selection: $selection) {
                        let showMarkers = !hideMostRecentMarkers || attempt.pegs != game.attempts.first?.pegs
                        if showMarkers, let matches = attempt.matches {
                            MatchMarkers(matches: matches)
                        }
                    }
                    .transition(.attempt(game.isOver))
                }
            }
            .scrollIndicators(.hidden)
            if !game.isOver {
                PegChooser(choices: game.pegChoices, onChoose: changePegAtSelection)
                    .transition(.pegChooser)
                    .frame(maxHeight: 90)
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Restart", systemImage: "arrow.circlepath", action: restart)
            }
            ToolbarItem {
                ElapsedTime(startTime: game.startTime, endTime: game.endTime)
                    .monospaced()
                    .lineLimit(1)
            }
        }
        .padding()
    }
    
    func changePegAtSelection(to peg: Peg) {
        game.setGuessPeg(peg, at: selection)
        selection = (selection + 1) % game.masterCode.pegs.count
    }
    
    func restart() {
        withAnimation(.restart) {
            restarting = game.isOver
            game.restart()
            selection = 0
        } completion: {
            withAnimation(.restart) {
                restarting = false
            }
        }
    }
    
    func guess() {
        withAnimation(.guess) {
            game.attemptGuess()
            selection = 0
            hideMostRecentMarkers = true
        } completion: {
            withAnimation(.guess) {
                hideMostRecentMarkers = false
            }
        }
    }
    
}


#Preview {
    @Previewable @State var game = CodeBreaker(pegChoices: [.brown, .yellow, .orange, .black, .green])
    NavigationStack {
        CodeBreakerView(game: game)
    }
}
