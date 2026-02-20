//
//  PegView.swift
//  CodeBreaker2
//
//  Created by jyotirmoy_halder on 12/2/26.
//

import SwiftUI

struct PegView: View {
    // MARK: Data In
    let peg: Peg
    
    let pegShape = Circle()
    
    // MARK: - Body
    var body: some View {
        pegShape
            .overlay {
                if peg == Code.missiongPeg {
                    pegShape
                        .strokeBorder(Color.gray)
                }
            }
            .contentShape(pegShape)
            .aspectRatio(1, contentMode: .fit)
            .foregroundStyle(peg)
    }
}

#Preview {
    PegView(peg: .indigo)
        .padding()
}
