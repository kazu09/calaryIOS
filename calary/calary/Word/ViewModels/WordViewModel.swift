//
//  WordViewModel.swift
//
//  Copyright © 2026 kazu09. All rights reserved.
//

import Foundation
import Observation

@MainActor
@Observable
final class WordViewModel {
    private let repository: any VocabularyRepository
    
    private(set) var cards: [VocabularyCard] = []
    var errorMessage: String?
    
    init(repository: any VocabularyRepository) {
        self.repository = repository
    }
    
    func load() {
        do {
            cards = try repository.fetchAll()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func diaryDate(for card: VocabularyCard) -> String {
        guard let date = card.diary?.entryDate else { return "登録元の日記なし" }
        return "\(date.formatted(date: .numeric, time: .omitted)) の日記より"
    }
}
