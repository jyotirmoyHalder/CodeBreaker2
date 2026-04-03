//
//  GameSummery.swift
//  CodeBreaker2
//
//  Created by jyotirmoy_halder on 31/3/26.
//

import SwiftUI

struct GameSummery: View {
    let game: CodeBreaker
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(game.name).font(.title)
            PegChooser(choices: game.pegChoices)
                .frame(maxHeight: 50)
            Text("^[\(game.attempts.count) attempt](inflect: true)")
        }
    }
}

#Preview {
    List {
        GameSummery(game: CodeBreaker(name: "Preview", pegChoices: [.red, .cyan, .yellow]))
    }
    
    List {
        GameSummery(game: CodeBreaker(name: "Preview", pegChoices: [.red, .cyan, .yellow]))
    }
    .listStyle(.plain)
}
