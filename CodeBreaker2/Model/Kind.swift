//
//  Kind.swift
//  CodeBreaker2
//
//  Created by jyotirmoy_halder on 6/4/26.
//


enum Kind: Equatable, RawRepresentable {
    typealias RawValue = String

    case master(isHidden: Bool)
    case guess
    case attempt([Match])
    case unknown

    var rawValue: String {
        switch self {
        case .master(let isHidden):
            return "master:\(isHidden)"
        case .guess:
            return "guess"
        case .attempt(let matches):
            let list = matches.map { $0.rawValue }.joined(separator: ",")
            return "attempt:\(list)"
        case .unknown:
            return "unknown"
        }
    }

    init(rawValue: String) {
        // Normalize input
        let parts = rawValue.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: false)
        let tag = parts.first.map(String.init)?.lowercased() ?? ""
        let payload = parts.count > 1 ? String(parts[1]) : nil

        switch tag {
        case "master":
            if let payload, let bool = Bool(payload) {
                self = .master(isHidden: bool)
            } else {
                self = .master(isHidden: false)
            }
        case "guess":
            self = .guess
        case "attempt":
            if let payload, !payload.isEmpty {
                let items = payload.split(separator: ",").map(String.init)
                let matches = items.compactMap { Match(rawValue: $0) }
                self = .attempt(matches)
            } else {
                self = .attempt([])
            }
        case "unknown":
            self = .unknown
        default:
            self = .unknown
        }
    }
}


enum Match: String {
    case nomatch
    case exact
    case inexact
}
