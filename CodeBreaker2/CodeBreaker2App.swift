//
//  CodeBreaker2App.swift
//  CodeBreaker2
//
//  Created by jyotirmoy_halder on 5/2/26.
//

import SwiftUI
import SwiftData

@main
struct CodeBreaker2App: App {
    var body: some Scene {
        WindowGroup {
            GameChooser()
                .modelContainer(for: CodeBreaker.self)
        }
    }
}
