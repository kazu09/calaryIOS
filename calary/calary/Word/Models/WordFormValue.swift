//
//  WordFormValue.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

struct WordFormValue: Equatable {
    let word: String
    let entries: [WordMeaningValue]
}

struct WordMeaningValue: Equatable {
    let japaneseMeaning: String
    let partOfSpeech: String?
}
