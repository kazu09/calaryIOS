//
//  WordDetailViewModel.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import Foundation
import Observation

@MainActor
@Observable
final class WordDetailViewModel {
    let card: VocabularyCard
    var errorMessage: String?
    
    private let repository: any VocabularyRepository
    
    init(
        card: VocabularyCard,
        repository: any VocabularyRepository
    ) {
        self.card = card
        self.repository = repository
    }
    
    var sortedMeanings: [VocabularyMeaning] {
        card.meanings.sorted { $0.displayOrder < $1.displayOrder }
    }
    
    var editorInitialValue: WordFormValue {
        let entries = sortedMeanings.map { meaning in
            WordMeaningValue(
                japaneseMeaning: meaning.japaneseMeaning,
                partOfSpeech: meaning.partOfSpeech
            )
        }
        return WordFormValue(word: card.word, entries: entries)
    }
    
    func updateCard(from value: WordFormValue) throws {
        try repository.update(card, from: value)
        errorMessage = nil
    }
}
