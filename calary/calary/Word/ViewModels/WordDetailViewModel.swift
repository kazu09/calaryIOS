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
    
    /// カード内の表示順で並べた意味一覧
    var sortedMeanings: [VocabularyMeaning] {
        card.meanings.sorted { $0.displayOrder < $1.displayOrder }
    }
    
    /// 単語編集画面へ渡す現在値
    var editorInitialValue: WordFormValue {
        let entries = sortedMeanings.map { meaning in
            WordMeaningValue(
                japaneseMeaning: meaning.japaneseMeaning,
                partOfSpeech: meaning.partOfSpeech
            )
        }
        return WordFormValue(word: card.word, entries: entries)
    }
    
    /// 単語カードと意味一覧を編集内容で更新する
    /// - Parameter value: 編集後の英単語と意味・品詞
    /// - Throws: Repositoryによる保存に失敗した場合のエラー
    func updateCard(from value: WordFormValue) throws {
        try repository.update(card, from: value)
        errorMessage = nil
    }
}
