//
//  Code.swift
//  CodeBreaker2
//
//  Created by jyotirmoy_halder on 11/2/26.
//


import SwiftUI
import SwiftData

@Model class Code {
    var _kind: String = Kind.unknown.rawValue
    var pegs: [Peg]
    var timestamp = Date.now
    
    var kind: Kind {
        get { return Kind(rawValue: _kind) }
        set { _kind = newValue.rawValue }
    }
    
    init(kind: Kind, pegs: [Peg] = Array(repeating: missiongPeg, count: 4)) {
        self.pegs = pegs
        self.kind = kind
    }
    
    static let missiongPeg: Peg = ""
    
    func randomize(from pegChoices: [Peg]) {
        for index in pegs.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missiongPeg
        }
        print(self)
    }
    
    // for showing or hiding master code
    var isHidden: Bool {
        switch kind {
        case .master(let isHidden): return isHidden
        default: return false
        }
    }
    
    func reset() {
        pegs = Array(repeating: Code.missiongPeg, count: 4)
    }
    
    var matches: [Match]? {
        switch kind {
        case .attempt(let matches):
            return matches
        default:
            return nil
        }
    }
    
    func match(against otherCode: Code) -> [Match] {
        var pegsToMatch = otherCode.pegs
        
        let backwardsExactMatches = pegs.indices.reversed().map { index in
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                pegsToMatch.remove(at: index)
                return Match.exact
            } else {
                return .nomatch
            }
        }
        let exactMatches = Array(backwardsExactMatches.reversed())
        return pegs.indices.map { index in
            if exactMatches[index] != .exact, let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                pegsToMatch.remove(at: matchIndex)
                return .inexact
            } else {
                return exactMatches[index]
            }
        }
        
        // MARK: USING FOR LOOP WE CAN ALSO IMPLEMENT THE CODE
        /*
//        for index in pegs.indices.reversed() {
//            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
//                results[index] = .exact
//                pegsToMatch.remove(at: index)
//            }
//        }
//        for index in pegs.indices {
//            if results[index] != .exact {
//                if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
//                    results[index] = .inexact
//                    pegsToMatch.remove(at: matchIndex)
//                }
//            }
//        }
//        return results
         */
    }
}
