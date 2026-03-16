//
//  HTMLDecoder.swift
//  TriviaGame
//
//  Created by Ritesh Kafle on 3/16/26.
//

import Foundation

func htmlDecoded(_ string: String) -> String {
    var result = string

    let entities: [String: String] = [
        "&quot;": "\"",
        "&#039;": "'",
        "&amp;": "&",
        "&lt;": "<",
        "&gt;": ">"
    ]

    for (entity, character) in entities {
        result = result.replacingOccurrences(of: entity, with: character)
    }

    return result
}
