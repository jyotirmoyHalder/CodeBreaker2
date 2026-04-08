//
//  GameList.swift
//  CodeBreaker2
//
//  Created by jyotirmoy_halder on 2/4/26.
//

import SwiftUI

struct GameList: View {
    
    // MARK: Data Shared with Me
    @Binding var selection: CodeBreaker?
    
    // MARK: Data Owned by Me
    @State private var games: [CodeBreaker] = []
    
    @State private var gameToEdit: CodeBreaker?
    
    
    var body: some View {
        List(selection: $selection) {
            ForEach (games) { game in
                NavigationLink(value: game) {
                    GameSummery(game: game)
                }
                .contextMenu {
                    editButton(for: game) // editing a game
                    deleteButton(for: game)
                }
                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                    editButton(for: game).tint(.accentColor) // editing a game
                }
            }
            .onDelete { offsets in
                games.remove(atOffsets: offsets)
            }
            .onMove { offsets, destination in
                games.move(fromOffsets: offsets, toOffset: destination)
            }
        }
        .onChange(of: games) {
            if let selection, !games.contains(selection) {
                self.selection = nil
            }
        }
        .listStyle(.plain)
        .toolbar {
            addButton
            EditButton() // editing the List of games
        }
        .onAppear { addSampleGames() }
    }
    
    var addButton: some View {
        Button("Add Game", systemImage: "plus") {
            gameToEdit = CodeBreaker(name: "Untitled", pegChoices: [Color.red, Color.blue].map{ $0.toHexString() ?? ""})
        }
        .sheet(isPresented: showGameEditor) {
            gameEditor
        }
    }
    
    func editButton(for game: CodeBreaker) -> some View {
        Button("Edit", systemImage: "pencil") {
            gameToEdit = game
        }
    }
    
    @ViewBuilder
    var gameEditor: some View {
        if let gameToEdit {
            let copyOfGameToEdit = CodeBreaker(name: gameToEdit.name, pegChoices: gameToEdit.pegChoices)
            GameEditor(game: copyOfGameToEdit) {
                if let index = games.firstIndex(of: gameToEdit) {
                    games[index] = copyOfGameToEdit
                } else {
                    games.insert(gameToEdit, at: 0)
                }
            }
        }
    }
    
    var showGameEditor: Binding<Bool> {
        Binding<Bool>(get: {
            gameToEdit != nil
        }, set: { newValue in
            if !newValue {
                gameToEdit = nil
            }
        })
    }
    
    func deleteButton(for game: CodeBreaker) -> some View {
        Button("Delete", systemImage: "minus.circle", role: .destructive) {
            withAnimation {
                games.removeAll { $0 == game }
            }
        }
    }
    
    func addSampleGames() {
        if games.isEmpty {
            games.append(CodeBreaker(name: "Mastermind", pegChoices: [Color.red, .green, .blue, .yellow].map{ $0.toHexString() ?? ""}))
            games.append(CodeBreaker(name: "Earth Tones", pegChoices: [Color.orange, .brown, .black, .yellow, .green].map{ $0.toHexString() ?? ""}))
            games.append(CodeBreaker(name: "Undersea", pegChoices: [Color.blue, .indigo, .cyan].map{ $0.toHexString() ?? ""}))
            selection = games[Int.random(in: 0..<games.count)]
        }
    }
}

#Preview {
    @Previewable @State var selection: CodeBreaker?
    NavigationStack {
        GameList(selection: $selection)
    }
}
