//
//  MatchMarkers.swift
//  CodeBreaker2
//
//  Created by jyotirmoy_halder on 5/2/26.
//

import SwiftUI


struct MatchMarkers: View {
    // MARK: Data In
    var matches: [Match]
    
    // MARK: - Body
    var body: some View {
        HStack {
            VStack {
                matchMarker(peg: 0)
                matchMarker(peg: 1)
            }
            VStack {
                matchMarker(peg: 2)
                matchMarker(peg: 3)
            }
        }
    }
    
    @ViewBuilder
    func matchMarker(peg: Int) -> some View {
        let exactCount = matches.count { $0 == .exact}
        let foundCount = matches.count { $0 != .nomatch}
        
        Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear, lineWidth: 2)
            .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    MatchMarkers(matches: [.exact, .inexact, .nomatch, .exact])
}
