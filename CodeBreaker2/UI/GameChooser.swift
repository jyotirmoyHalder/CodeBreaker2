//
//  GameChooser.swift
//  CodeBreaker2
//
//  Created by jyotirmoy_halder on 31/3/26.
//

import SwiftUI

struct GameChooser: View {
    // MARK: Data Owned by Me
    @State private var games: [CodeBreaker] = []
    
    var body: some View {
        List(games, id: \.pegChoices) { game in
            VStack(alignment: .leading) {
                Text(game.name).font(.title)
                PegChooser(choices: game.pegChoices)
                    .frame(maxHeight: 50)
                Text("^[\(game.attempts.count) attempt](inflect: true)")
            }
        }
        .onAppear {
            games.append(CodeBreaker(name: "Mastermind", pegChoices: [.red, .green, .blue, .yellow]))
            games.append(CodeBreaker(name: "Earth Tones", pegChoices: [.orange, .brown, .black, .yellow, .green]))
            games.append(CodeBreaker(name: "Undersea", pegChoices: [.blue, .indigo, .cyan]))
        }
    }
}

#Preview {
    GameChooser()
}
