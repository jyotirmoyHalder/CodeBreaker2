//
//  CodeBreaker.swift
//  CodeBreaker2
//
//  Created by jyotirmoy_halder on 5/2/26.
//

import Foundation
import SwiftData


typealias Peg = String

@Model class CodeBreaker {
    
    var name: String
    @Relationship(deleteRule: .cascade) var masterCode: Code = Code(kind: .master(isHidden: true))
    @Relationship(deleteRule: .cascade) var guess: Code = Code(kind: .guess)
    @Relationship(deleteRule: .cascade) var attempts: [Code] = []
    var pegChoices: [Peg]
    @Transient var startTime: Date?
    var endTime: Date? 
    var elapsedTime: TimeInterval = 0
    
    init(name: String = "Code Breaker", pegChoices: [Peg] ) {
        self.name = name
        self.pegChoices = pegChoices
        masterCode.randomize(from: pegChoices)
    }
    
    func startTimer() {
        if startTime == nil, !isOver {
            startTime = .now
        }
    }
    
    func pauseTimer() {
        if let startTime {
            elapsedTime += Date.now.timeIntervalSince(startTime)
        }
        startTime = nil
    }
    
    var isOver: Bool {
        attempts.first?.pegs == masterCode.pegs
    }
    
    func restart() {
        masterCode.kind = .master(isHidden: true)
        masterCode.randomize(from: pegChoices)
        guess.reset()
        attempts.removeAll()
        startTime = .now
        endTime = nil
        elapsedTime = 0
    }
    
    func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    func attemptGuess() {
        guard !attempts.contains(where: { $0.pegs == guess.pegs }) else { return }
        let attempt = Code(
            kind: .attempt(guess.match(against: masterCode)),
            pegs: guess.pegs
        )
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.insert(attempt, at: 0)
        guess.reset()
        if isOver {
            endTime = .now
            masterCode.kind = .master(isHidden: false)
            pauseTimer()
        }
    }
    
//    mutating func changeGuessPeg(at index: Int) {
//        let existingPeg = guess.pegs[index]
//        if let indexofExistingPegInPegChoices = pegChoices.firstIndex(of: existingPeg) {
//            let newPeg = pegChoices[(indexofExistingPegInPegChoices + 1) % pegChoices.count]
//            guess.pegs[index] = newPeg
//        } else {
//            guess.pegs[index] = pegChoices.first ?? Code.missiongPeg
//        }
//    }
}



// MARK: WE DON'T NEED THIS CODE AS WE CONVERTED THIS CLASS TO @MODEL
// As we converted the @Observable to @Mode now our class is hashable, equatable, codable
/*

extension CodeBreaker: Identifiable, Hashable, Equatable {
    static func == (lhs: CodeBreaker, rhs: CodeBreaker) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

*/
